import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import 'recurrence_override_id.dart';

/// Constrói a `Transaction` que materializa (ou atualiza) um `CheckInItem`
/// num dado status — compartilhado por Confirm/Adjust/Cancel, que só
/// diferem no `status` e, no caso do ajuste, no valor.
Transaction materializeCheckInItem(
  CheckInItem item, {
  required TransactionStatus status,
  int? amountCents,
}) {
  final now = DateTime.now();
  return Transaction(
    id: item.transactionId ?? recurrenceOverrideId(item.recurrenceRuleId!, item.date),
    accountId: item.accountId,
    description: item.description,
    amountCents: amountCents ?? item.amountCents,
    date: item.date,
    status: status,
    category: item.category,
    recurrenceRuleId: item.recurrenceRuleId,
    createdAt: item.createdAt ?? now,
    updatedAt: now,
  );
}
