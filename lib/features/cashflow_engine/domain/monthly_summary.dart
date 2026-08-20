import '../../../core/utils/date_only.dart';
import '../../../core/utils/transaction_category.dart';
import '../../credit_cards/domain/entities/invoice_item.dart';
import '../../transactions/domain/entities/recurrence_rule.dart';
import '../../transactions/domain/entities/transaction.dart';
import 'entities/monthly_summary.dart';
import 'recurrence_expansion.dart';

/// Função pura, sem I/O — mesmo espírito de `project_cashflow.dart`.
/// Junta `Transaction`s pontuais (excluindo `cancelado`/`adiado`, mesmo
/// filtro da engine) com ocorrências virtuais de `RecurrenceRule` que
/// caem no mês e ainda não têm override, igual ao passo 1-2 de
/// `projectCashflow` — só que agregando em totais do mês em vez de saldo
/// diário.
///
/// Pagamento de fatura (`invoicePaymentForId != null`) é excluído das
/// saídas: a compra já é contada em `cardSpendCents` pela data da compra;
/// contar o pagamento de novo pela data de vencimento duplicaria o mesmo
/// gasto (decisão registrada em docs/ROADMAP.md, M7 #021).
MonthlySummary summarizeMonth({
  required List<Transaction> transactions,
  required List<RecurrenceRule> recurrenceRules,
  required List<InvoiceItem> invoiceItems,
  required int year,
  required int month,
  required int savingsTargetPercent,
  required DateOnly today,
}) {
  final monthStart = DateOnly(year, month, 1);
  final monthEnd = clampedMonthDate(year, month, 32);

  final overriddenSlots = transactions
      .where((t) => t.recurrenceRuleId != null)
      .map((t) => (t.recurrenceRuleId, t.date))
      .toSet();

  final virtualEvents = <({int amountCents, TransactionCategory category})>[];
  for (final rule in recurrenceRules) {
    for (final date in expandRecurrence(rule, monthStart, monthEnd)) {
      if (!overriddenSlots.contains((rule.id, date))) {
        virtualEvents.add((amountCents: rule.amountCents, category: rule.category));
      }
    }
  }

  final pointAmounts = transactions
      .where((t) => t.date >= monthStart && t.date <= monthEnd)
      .where((t) => t.status != TransactionStatus.cancelado)
      .where((t) => t.status != TransactionStatus.adiado)
      .toList();

  final incomeCents = pointAmounts
          .where((t) => t.amountCents > 0)
          .fold<int>(0, (sum, t) => sum + t.amountCents) +
      virtualEvents
          .where((e) => e.amountCents > 0)
          .fold<int>(0, (sum, e) => sum + e.amountCents);

  final expensePoints =
      pointAmounts.where((t) => t.amountCents < 0 && t.invoicePaymentForId == null);
  final expenseVirtuals = virtualEvents.where((e) => e.amountCents < 0);
  final expensesCents = -(expensePoints.fold<int>(0, (sum, t) => sum + t.amountCents) +
      expenseVirtuals.fold<int>(0, (sum, e) => sum + e.amountCents));

  final monthInvoiceItems =
      invoiceItems.where((i) => i.purchaseDate >= monthStart && i.purchaseDate <= monthEnd);
  final cardSpendCents = -monthInvoiceItems.fold<int>(0, (sum, i) => sum + i.amountCents);

  final costOfLivingCents = expensesCents + cardSpendCents;

  // Mesma composição de costOfLivingCents (saídas + gasto de cartão),
  // só que bucketada por categoria em vez de somada num total — a soma
  // dos valores bate com costOfLivingCents (M7, #029).
  final categoryCents = <TransactionCategory, int>{};
  for (final t in expensePoints) {
    categoryCents[t.category] = (categoryCents[t.category] ?? 0) - t.amountCents;
  }
  for (final e in expenseVirtuals) {
    categoryCents[e.category] = (categoryCents[e.category] ?? 0) - e.amountCents;
  }
  for (final i in monthInvoiceItems) {
    categoryCents[i.category] = (categoryCents[i.category] ?? 0) - i.amountCents;
  }

  final isCurrentMonth = today.year == year && today.month == month;
  final elapsedDays = isCurrentMonth ? today.day : monthEnd.day;
  final dailyCostCents = costOfLivingCents ~/ elapsedDays;

  final savedCents = incomeCents - costOfLivingCents;
  final savingsPercent = incomeCents == 0 ? 0.0 : (savedCents / incomeCents) * 100;

  return MonthlySummary(
    incomeCents: incomeCents,
    expensesCents: expensesCents,
    cardSpendCents: cardSpendCents,
    costOfLivingCents: costOfLivingCents,
    dailyCostCents: dailyCostCents,
    savedCents: savedCents,
    savingsPercent: savingsPercent,
    isSavingsOnTarget: savingsPercent >= savingsTargetPercent,
    categoryCents: categoryCents,
  );
}

/// Categorias tratadas como "necessidade" pra regra 50/30/20 — o resto
/// (`categoryCents` menos essas) cai em "desejo" por subtração, não por
/// um segundo conjunto explícito (evita esquecer de atualizar os dois
/// quando uma categoria nova aparecer em `TransactionCategory`).
const necessidadeCategories = {
  TransactionCategory.moradia,
  TransactionCategory.alimentacao,
  TransactionCategory.transporte,
  TransactionCategory.saude,
};

typedef Budget503020 = ({
  int necessidadesCents,
  int desejosCents,
  int reservaCents,
  double necessidadesPercent,
  double desejosPercent,
  double reservaPercent,
});

/// Guia 50/30/20 (M7, #029) — necessidades/desejos vêm de `categoryCents`
/// já calculado; reserva reusa `savedCents`/`savingsPercent` (sobra do
/// mês, não aporte real de `Reserve` — mesma limitação já registrada no
/// #021: não existe ledger de aporte). Pode ficar negativo quando o mês
/// gastou mais do que ganhou — de propósito, é o sinal mais importante
/// pra essa tela.
Budget503020 budget503020(MonthlySummary summary) {
  final necessidadesCents = summary.categoryCents.entries
      .where((e) => necessidadeCategories.contains(e.key))
      .fold<int>(0, (sum, e) => sum + e.value);
  final desejosCents = summary.costOfLivingCents - necessidadesCents;
  final income = summary.incomeCents;
  double pct(int cents) => income == 0 ? 0.0 : (cents / income) * 100;

  return (
    necessidadesCents: necessidadesCents,
    desejosCents: desejosCents,
    reservaCents: summary.savedCents,
    necessidadesPercent: pct(necessidadesCents),
    desejosPercent: pct(desejosCents),
    reservaPercent: summary.savingsPercent,
  );
}
