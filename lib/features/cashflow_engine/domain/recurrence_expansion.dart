import '../../../core/utils/date_only.dart';
import '../../transactions/domain/entities/recurrence_rule.dart';

/// Datas em que [rule] tem ocorrência entre [from] e [to] (inclusive),
/// respeitando `endDate`/`occurrenceCount` e o clamp de dia inválido
/// (docs/CASHFLOW_ENGINE.md §2/§3). Usado pela engine (`project_cashflow.dart`,
/// horizonte inteiro) e pelo check-in diário (`get_today_check_in_items.dart`,
/// um único dia — `expandRecurrence(rule, today, today)`).
List<DateOnly> expandRecurrence(
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
      return base.addMonths(n * rule.interval);
    case RecurrenceFrequency.yearly:
      return clampedMonthDate(
        base.year + n * rule.interval,
        base.month,
        base.day,
      );
    case RecurrenceFrequency.custom:
      return base.addDays(n * rule.interval);
  }
}
