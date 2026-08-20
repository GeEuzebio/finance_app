import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/transaction_category.dart';

part 'monthly_summary.freezed.dart';

/// Resumo de um mês — Performance/Economia/Custo de vida (M7, #021).
/// `expensesCents` já exclui pagamento de fatura (evento que a própria
/// engine gera a partir da fatura em `project_cashflow.dart`) pra não
/// somar a mesma compra duas vezes com `cardSpendCents` (docs/ROADMAP.md).
@freezed
class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required int incomeCents,
    required int expensesCents,
    required int cardSpendCents,
    required int costOfLivingCents,
    required int dailyCostCents,
    required int savedCents,
    required double savingsPercent,
    required bool isSavingsOnTarget,
    // Mesma composição de custo de vida (saídas + gasto de cartão),
    // bucketada por categoria — soma dos valores bate com
    // costOfLivingCents (M7, #029).
    required Map<TransactionCategory, int> categoryCents,
  }) = _MonthlySummary;
}
