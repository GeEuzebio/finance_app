import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/transactions/data/repositories/recurrence_repository_impl.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recurrenceRuleToJson usa a coluna recurrence_interval (evita a palavra reservada)', () {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: DateOnly(2026, 1, 5),
      createdAt: DateTime.utc(2026, 1, 1),
    );

    final json = recurrenceRuleToJson(rule);
    expect(json['recurrence_interval'], 1);
    expect(json.containsKey('interval'), isFalse);
  });

  test('recurrenceRuleFromJson(recurrenceRuleToJson(x)) faz roundtrip, com endDate/occurrenceCount', () {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'assinatura',
      amountCents: -8000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: DateOnly(2026, 1, 5),
      endDate: DateOnly(2026, 12, 5),
      occurrenceCount: null,
      category: TransactionCategory.lazer,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    final json = recurrenceRuleToJson(rule);
    expect(json['category'], 'lazer');
    expect(recurrenceRuleFromJson(json), rule);
  });
}
