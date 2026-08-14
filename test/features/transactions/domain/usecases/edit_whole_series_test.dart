import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/edit_whole_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

void main() {
  late _MockRecurrenceRepository repository;
  late EditWholeSeries useCase;

  RecurrenceRule buildRule({int interval = 1}) => RecurrenceRule(
        id: 'r1',
        accountId: 'a1',
        description: 'aluguel',
        amountCents: -300000,
        frequency: RecurrenceFrequency.monthly,
        interval: interval,
        startDate: DateOnly(2026, 1, 5),
        createdAt: DateTime(2026),
      );

  setUpAll(() => registerFallbackValue(buildRule()));

  setUp(() {
    repository = _MockRecurrenceRepository();
    useCase = EditWholeSeries(repository);
  });

  test('atualiza a regra in-place via upsert', () async {
    final rule = buildRule();
    when(() => repository.upsert(rule)).thenAnswer((_) async => const Right(unit));

    final result = await useCase(rule);

    expect(result.isRight(), isTrue);
    verify(() => repository.upsert(rule)).called(1);
  });

  test('rejeita regra inválida sem chamar upsert', () async {
    final result = await useCase(buildRule(interval: 0));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });
}
