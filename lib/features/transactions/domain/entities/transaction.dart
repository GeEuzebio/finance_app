import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';
import '../../../../core/utils/transaction_category.dart';

part 'transaction.freezed.dart';

enum TransactionStatus { previsto, confirmado, ajustado, adiado, cancelado }

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String accountId,
    required String description,
    required int amountCents,
    required DateOnly date,
    required TransactionStatus status,
    String? recurrenceRuleId,
    String? originalTransactionId,
    String? transferGroupId,
    String? invoicePaymentForId,
    // Preenchido só em lançamentos vindos de importação OFX/CSV
    // (M7, #023) — usado pra deduplicar reimportação do mesmo período.
    // `null` em todo o resto do app.
    String? externalId,
    // Pra onde foi o gasto, não como foi pago (M7, #029).
    @Default(TransactionCategory.outros) TransactionCategory category,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;
}
