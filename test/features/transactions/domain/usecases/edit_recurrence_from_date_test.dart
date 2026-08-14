import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/edit_recurrence_from_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

void main() {
  late _MockRecurrenceRepository repository;
  late EditRecurrenceFromDate useCase;

  RecurrenceRule currentRule() => RecurrenceRule(
        id: 'r1',
        accountId: 'a1',
        description: 'aluguel',
        amountCents: -300000,
        frequency: RecurrenceFrequency.monthly,
        interval: 1,
        startDate: DateOnly(2026, 1, 5),
        createdAt: DateTime(2026),
      );

  setUpAll(() => registerFallbackValue(currentRule()));

  setUp(() {
    repository = _MockRecurrenceRepository();
    useCase = EditRecurrenceFromDate(repository);
  });

  test('fecha a regra atual com endDate = fromDate-1 e cria uma nova a partir de fromDate', () async {
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(
      currentRule: currentRule(),
      fromDate: DateOnly(2026, 6, 5),
      newAmountCents: -320000,
      newFrequency: RecurrenceFrequency.monthly,
      newInterval: 1,
    );

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => repository.upsert(captureAny())).captured.cast<RecurrenceRule>();
    expect(captured.length, 2);

    final closed = captured.firstWhere((r) => r.id == 'r1');
    expect(closed.endDate, DateOnly(2026, 6, 4));
    expect(closed.occurrenceCount, isNull);

    final created = captured.firstWhere((r) => r.id != 'r1');
    expect(created.startDate, DateOnly(2026, 6, 5));
    expect(created.amountCents, -320000);
  });

  test('não persiste nada se os novos parâmetros forem inválidos', () async {
    final result = await useCase(
      currentRule: currentRule(),
      fromDate: DateOnly(2026, 6, 5),
      newAmountCents: -320000,
      newFrequency: RecurrenceFrequency.monthly,
      newInterval: 0,
    );

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });

  test('se o fechamento da regra atual falhar, não tenta criar a nova', () async {
    when(() => repository.upsert(any(
          that: predicate<RecurrenceRule>((r) => r.id == 'r1'),
        ))).thenAnswer((_) async => const Left(DatabaseFailure('erro')));

    final result = await useCase(
      currentRule: currentRule(),
      fromDate: DateOnly(2026, 6, 5),
      newAmountCents: -320000,
      newFrequency: RecurrenceFrequency.monthly,
      newInterval: 1,
    );

    expect(result.isLeft(), isTrue);
    verifyNever(() => repository.upsert(any(
          that: predicate<RecurrenceRule>((r) => r.id != 'r1'),
        )));
  });
}
