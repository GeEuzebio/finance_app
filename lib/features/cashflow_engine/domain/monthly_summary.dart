import '../../credit_cards/domain/entities/invoice_item.dart';
import '../../transactions/domain/entities/recurrence_rule.dart';
import '../../transactions/domain/entities/transaction.dart';
import 'entities/monthly_summary.dart';
import 'recurrence_expansion.dart';
import '../../../core/utils/date_only.dart';

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

  final virtualAmounts = <int>[];
  for (final rule in recurrenceRules) {
    for (final date in expandRecurrence(rule, monthStart, monthEnd)) {
      if (!overriddenSlots.contains((rule.id, date))) {
        virtualAmounts.add(rule.amountCents);
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
      virtualAmounts.where((a) => a > 0).fold<int>(0, (sum, a) => sum + a);

  final expensesCents = -(pointAmounts
          .where((t) => t.amountCents < 0 && t.invoicePaymentForId == null)
          .fold<int>(0, (sum, t) => sum + t.amountCents) +
      virtualAmounts.where((a) => a < 0).fold<int>(0, (sum, a) => sum + a));

  final cardSpendCents = -invoiceItems
      .where((i) => i.purchaseDate >= monthStart && i.purchaseDate <= monthEnd)
      .fold<int>(0, (sum, i) => sum + i.amountCents);

  final costOfLivingCents = expensesCents + cardSpendCents;

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
  );
}
