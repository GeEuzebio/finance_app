import '../../../core/utils/date_only.dart';
import '../../credit_cards/domain/entities/credit_card.dart';
import '../../credit_cards/domain/entities/invoice.dart';
import '../../credit_cards/domain/entities/invoice_item.dart';
import '../../reserves/domain/entities/reserve.dart';
import '../../transactions/domain/entities/recurrence_rule.dart';
import '../../transactions/domain/entities/transaction.dart';
import 'entities/account_snapshot.dart';
import 'entities/daily_balance.dart';

/// Função pura, determinística, sem I/O (docs/CASHFLOW_ENGINE.md §1).
/// Não lê relógio: `horizonStart`/`horizonEnd` são os únicos parâmetros de
/// "quando" que a função enxerga.
List<DailyBalance> projectCashflow({
  required List<AccountSnapshot> accounts,
  required List<Transaction> transactions,
  required List<RecurrenceRule> recurrenceRules,
  required List<CreditCard> creditCards,
  required List<Invoice> invoices,
  required List<InvoiceItem> invoiceItems,
  required List<Reserve> reserves,
  required DateOnly horizonStart,
  required DateOnly horizonEnd,
}) {
  assert(!horizonStart.isAfter(horizonEnd));

  final activeAccounts = accounts.where((a) => !a.archived).toList();
  if (activeAccounts.isEmpty) return const [];

  // 1. Expandir recorrências em ocorrências virtuais dentro do horizonte.
  final virtualEvents = <_Event>[];
  for (final rule in recurrenceRules) {
    for (final date in _expandRecurrence(rule, horizonStart, horizonEnd)) {
      virtualEvents.add(_Event(
        accountId: rule.accountId,
        amountCents: rule.amountCents,
        date: date,
        recurrenceRuleId: rule.id,
      ));
    }
  }

  // 2. Remover ocorrências virtuais já sobrescritas por uma Transaction
  //    concreta vinculada à mesma regra, na mesma data.
  // ponytail: usa t.date como "data da ocorrência original" — cobre ajuste
  // de valor mantendo a data. Um ajuste que também move a data exigiria um
  // campo explícito de data original na Transaction, que não existe ainda;
  // nenhum dos 15 casos de docs/CASHFLOW_ENGINE.md §5 exercita esse caso.
  final overriddenSlots = transactions
      .where((t) => t.recurrenceRuleId != null)
      .map((t) => (t.recurrenceRuleId, t.date))
      .toSet();
  virtualEvents.removeWhere(
    (e) => overriddenSlots.contains((e.recurrenceRuleId, e.date)),
  );

  // 3. Resolver faturas de cartão em débitos na conta de pagamento.
  final creditCardsById = {for (final c in creditCards) c.id: c};
  final invoiceDebits = <_Event>[];
  for (final invoice in invoices) {
    final totalCents = invoiceItems
        .where((i) => i.invoiceId == invoice.id)
        .fold(0, (sum, i) => sum + i.amountCents);
    final hasConcretePayment =
        transactions.any((t) => t.invoicePaymentForId == invoice.id);
    if (totalCents != 0 && !hasConcretePayment) {
      final creditCard = creditCardsById[invoice.creditCardId]!;
      invoiceDebits.add(_Event(
        accountId: creditCard.paymentAccountId,
        amountCents: totalCents,
        date: invoice.dueDate,
        recurrenceRuleId: null,
      ));
    }
  }

  // 4. Montar timeline final: pontuais + recorrentes virtuais + débitos de
  //    fatura, excluindo cancelado e adiado (a nova ocorrência do
  //    adiamento soma na sua própria data, como uma Transaction normal).
  final pointEvents = transactions
      .where((t) => t.status != TransactionStatus.cancelado)
      .where((t) => t.status != TransactionStatus.adiado)
      .map((t) => _Event(
            accountId: t.accountId,
            amountCents: t.amountCents,
            date: t.date,
            recurrenceRuleId: t.recurrenceRuleId,
          ));

  final allEvents = [...pointEvents, ...virtualEvents, ...invoiceDebits];

  // 5. Indexar eventos por (conta, data) — O(1) por dia em vez de O(n).
  final eventsByAccount = <String, Map<DateOnly, List<_Event>>>{};
  for (final event in allEvents) {
    final byDate = eventsByAccount.putIfAbsent(event.accountId, () => {});
    byDate.putIfAbsent(event.date, () => []).add(event);
  }

  // 6. Acumular saldo diário por conta.
  final perAccountResults = <DailyBalance>[];
  final perAccountByDate = <String, Map<DateOnly, DailyBalance>>{};
  for (final account in activeAccounts) {
    var balance = account.initialBalanceCents;
    var day = horizonStart.isBefore(account.initialBalanceDate)
        ? horizonStart
        : account.initialBalanceDate;
    final byDate = eventsByAccount[account.id] ?? const {};
    final resultsByDate = <DateOnly, DailyBalance>{};

    while (!day.isAfter(horizonEnd)) {
      final dayEvents = byDate[day] ?? const [];
      final credits = dayEvents
          .where((e) => e.amountCents > 0)
          .fold(0, (sum, e) => sum + e.amountCents);
      final debits = dayEvents
          .where((e) => e.amountCents < 0)
          .fold(0, (sum, e) => sum - e.amountCents);
      final opening = balance;
      balance = balance + credits - debits;

      if (!day.isBefore(horizonStart)) {
        final dailyBalance = DailyBalance(
          date: day,
          accountId: account.id,
          openingBalanceCents: opening,
          closingBalanceCents: balance,
          projectedCreditsCents: credits,
          projectedDebitsCents: debits,
        );
        perAccountResults.add(dailyBalance);
        resultsByDate[day] = dailyBalance;
      }
      day = day.addDays(1);
    }
    perAccountByDate[account.id] = resultsByDate;
  }

  // 7. Consolidar (soma de todas as contas ativas por dia) + saldo livre.
  final activeReservesCents =
      reserves.fold(0, (sum, r) => sum + r.currentAmountCents);
  final consolidatedResults = <DailyBalance>[];
  var day = horizonStart;
  while (!day.isAfter(horizonEnd)) {
    var opening = 0;
    var closing = 0;
    var credits = 0;
    var debits = 0;
    for (final account in activeAccounts) {
      final daily = perAccountByDate[account.id]?[day];
      if (daily == null) continue;
      opening += daily.openingBalanceCents;
      closing += daily.closingBalanceCents;
      credits += daily.projectedCreditsCents;
      debits += daily.projectedDebitsCents;
    }
    consolidatedResults.add(DailyBalance(
      date: day,
      openingBalanceCents: opening,
      closingBalanceCents: closing,
      projectedCreditsCents: credits,
      projectedDebitsCents: debits,
      freeBalanceCents: closing - activeReservesCents,
    ));
    day = day.addDays(1);
  }

  return [...perAccountResults, ...consolidatedResults];
}

class _Event {
  _Event({
    required this.accountId,
    required this.amountCents,
    required this.date,
    required this.recurrenceRuleId,
  });

  final String accountId;
  final int amountCents;
  final DateOnly date;
  final String? recurrenceRuleId;
}

List<DateOnly> _expandRecurrence(
  RecurrenceRule rule,
  DateOnly from,
  DateOnly to,
) {
  final dates = <DateOnly>[];
  var cursor = rule.startDate;
  var n = 0;
  final effectiveEnd = rule.endDate ?? to;

  while (!cursor.isAfter(to) &&
      !cursor.isAfter(effectiveEnd) &&
      (rule.occurrenceCount == null || n < rule.occurrenceCount!)) {
    if (!cursor.isBefore(from)) dates.add(cursor);
    n += 1;
    cursor = _nextOccurrence(rule, n);
  }
  return dates;
}

DateOnly _nextOccurrence(RecurrenceRule rule, int n) {
  final base = rule.startDate;
  switch (rule.frequency) {
    case RecurrenceFrequency.weekly:
      return base.addDays(n * 7);
    case RecurrenceFrequency.monthly:
      final monthsFromBase = base.month - 1 + n * rule.interval;
      return _clampedMonthDate(
        base.year + monthsFromBase ~/ 12,
        monthsFromBase % 12 + 1,
        base.day,
      );
    case RecurrenceFrequency.yearly:
      return _clampedMonthDate(
        base.year + n * rule.interval,
        base.month,
        base.day,
      );
    case RecurrenceFrequency.custom:
      return base.addDays(n * rule.interval);
  }
}

/// Gera a data pedida; se o dia não existir naquele mês (ex.: dia 31 em
/// fevereiro), usa o último dia real do mês (docs/CASHFLOW_ENGINE.md §3 —
/// regra de dia inválido).
DateOnly _clampedMonthDate(int year, int month, int day) {
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  return DateOnly(year, month, day > lastDayOfMonth ? lastDayOfMonth : day);
}
