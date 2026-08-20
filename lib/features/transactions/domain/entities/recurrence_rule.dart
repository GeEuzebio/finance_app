import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';
import '../../../../core/utils/transaction_category.dart';

part 'recurrence_rule.freezed.dart';

enum RecurrenceFrequency { weekly, monthly, yearly, custom }

@freezed
class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    required String id,
    required String accountId,
    required String description,
    required int amountCents,
    required RecurrenceFrequency frequency,
    required int interval,
    required DateOnly startDate,
    DateOnly? endDate,
    int? occurrenceCount,
    @Default(false) bool isVariable,
    @Default(TransactionCategory.outros) TransactionCategory category,
    required DateTime createdAt,
  }) = _RecurrenceRule;
}
