import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

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
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;
}
