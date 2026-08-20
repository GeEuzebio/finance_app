import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../cashflow_engine/domain/recurrence_expansion.dart';
import '../../../credit_cards/domain/repositories/credit_card_repository.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/recurrence_repository.dart';
import '../repositories/transaction_repository.dart';

/// Detalhamento de um dia da Projeção (M7, #026) — mesma junção de
/// `Transaction` real + ocorrência virtual de `RecurrenceRule` que
/// `GetTodayCheckInItems` faz pro Check-in, mas pra um dia qualquer e sem
/// o filtro "só previsto" (aqui é um extrato, não uma fila de ação: um
/// dia já confirmado/ajustado continua aparecendo). Também resolve o
/// débito sintético de fatura vencendo nesse dia
/// (`project_cashflow.dart` passo 3), senão a soma do detalhamento não
/// bateria com a Diferença mostrada na grade da Projeção.
@injectable
class GetDayLedger {
  GetDayLedger(this._accounts, this._transactions, this._recurrences, this._creditCards);

  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final RecurrenceRepository _recurrences;
  final CreditCardRepository _creditCards;

  Future<Either<Failure, List<CheckInItem>>> call({required DateOnly day}) {
    return guardDatabase(() async {
      final accounts = await _unwrap(_accounts.getAll());
      final accountNames = {for (final a in accounts) a.id: a.name};

      final transactions = await _unwrap(_transactions.getAll());
      final materialized = transactions
          .where((t) => t.date == day)
          .where((t) => t.status != TransactionStatus.cancelado)
          .where((t) => t.status != TransactionStatus.adiado)
          .map((t) => CheckInItem(
                transactionId: t.id,
                accountId: t.accountId,
                accountName: accountNames[t.accountId] ?? '—',
                description: t.description,
                amountCents: t.amountCents,
                date: t.date,
                category: t.category,
                recurrenceRuleId: t.recurrenceRuleId,
                createdAt: t.createdAt,
              ));

      final resolvedRuleIds = transactions
          .where((t) => t.recurrenceRuleId != null && t.date == day)
          .map((t) => t.recurrenceRuleId)
          .toSet();

      final rules = await _unwrap(_recurrences.getAll());
      final virtual = rules
          .where((r) => !resolvedRuleIds.contains(r.id))
          .where((r) => expandRecurrence(r, day, day).isNotEmpty)
          .map((r) => CheckInItem(
                accountId: r.accountId,
                accountName: accountNames[r.accountId] ?? '—',
                description: r.description,
                amountCents: r.amountCents,
                date: day,
                category: r.category,
                recurrenceRuleId: r.id,
              ));

      final cards = await _unwrap(_creditCards.getAllCards());
      final cardsById = {for (final c in cards) c.id: c};
      final invoices = await _unwrap(_creditCards.getAllInvoices());
      final invoiceItems = await _unwrap(_creditCards.getAllItems());
      final invoiceDebits = invoices
          .where((i) => i.dueDate == day)
          .map((i) {
            final totalCents = invoiceItems
                .where((item) => item.invoiceId == i.id)
                .fold(0, (sum, item) => sum + item.amountCents);
            final hasConcretePayment =
                transactions.any((t) => t.invoicePaymentForId == i.id);
            if (totalCents == 0 || hasConcretePayment) return null;
            final card = cardsById[i.creditCardId]!;
            return CheckInItem(
              accountId: card.paymentAccountId,
              accountName: accountNames[card.paymentAccountId] ?? '—',
              description: 'Fatura ${card.name}',
              // Mesma convenção de project_cashflow.dart passo 3: soma dos
              // InvoiceItem já vem negativa (débito), sem inverter sinal.
              amountCents: totalCents,
              date: day,
            );
          })
          .whereType<CheckInItem>();

      return [...materialized, ...virtual, ...invoiceDebits];
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
