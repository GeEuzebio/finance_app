import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/create_recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

void main() {
  late _MockRecurrenceRepository repository;
  late CreateRecurrenceRule useCase;

  RecurrenceRule buildRule({DateOnly? endDate, int? occurrenceCount, int interval = 1}) =>
      RecurrenceRule(
        id: 'r1',
        accountId: 'a1',
        description: 'aluguel',
        amountCents: -300000,
        frequency: RecurrenceFrequency.monthly,
        interval: interval,
        startDate: DateOnly(2026, 1, 5),
        endDate: endDate,
        occurrenceCount: occurrenceCount,
        createdAt: DateTime(2026),
      );

  setUpAll(() => registerFallbackValue(buildRule()));

  setUp(() {
    repository = _MockRecurrenceRepository();
    useCase = CreateRecurrenceRule(repository);
  });

  test('regra válida é persistida via repository.upsert', () async {
    final rule = buildRule();
    when(() => repository.upsert(rule)).thenAnswer((_) async => const Right(unit));

    final result = await useCase(rule);

    expect(result.isRight(), isTrue);
    verify(() => repository.upsert(rule)).called(1);
  });

  test('rejeita endDate e occurrenceCount juntos sem chamar o repositório', () async {
    final rule = buildRule(endDate: DateOnly(2026, 12, 31), occurrenceCount: 5);

    final result = await useCase(rule);

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });

  test('rejeita interval < 1', () async {
    final result = await useCase(buildRule(interval: 0));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
  });

  test('rejeita endDate antes de startDate', () async {
    final result = await useCase(buildRule(endDate: DateOnly(2025, 1, 1)));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
  });
}
