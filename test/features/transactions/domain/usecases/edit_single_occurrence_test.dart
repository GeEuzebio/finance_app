import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/edit_single_occurrence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late EditSingleOccurrence useCase;

  setUpAll(() => registerFallbackValue(
        Transaction(
          id: 'fallback',
          accountId: 'a',
          description: 'x',
          amountCents: 0,
          date: DateOnly(2026, 1, 1),
          status: TransactionStatus.previsto,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ));

  setUp(() {
    repository = _MockTransactionRepository();
    useCase = EditSingleOccurrence(repository);
  });

  test('cria Transaction vinculada com status ajustado, na mesma data da ocorrência', () async {
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(
      recurrenceRuleId: 'r1',
      accountId: 'a1',
      occurrenceDate: DateOnly(2026, 8, 5),
      amountCents: -35000,
      description: 'aluguel ajustado',
    );

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => repository.upsert(captureAny())).captured.single as Transaction;
    expect(captured.recurrenceRuleId, 'r1');
    expect(captured.date, DateOnly(2026, 8, 5));
    expect(captured.status, TransactionStatus.ajustado);
    expect(captured.amountCents, -35000);
  });

  test('editar a mesma ocorrência duas vezes gera o mesmo id (idempotente)', () async {
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));

    await useCase(
      recurrenceRuleId: 'r1',
      accountId: 'a1',
      occurrenceDate: DateOnly(2026, 8, 5),
      amountCents: -1,
      description: 'x',
    );
    await useCase(
      recurrenceRuleId: 'r1',
      accountId: 'a1',
      occurrenceDate: DateOnly(2026, 8, 5),
      amountCents: -2,
      description: 'y',
    );

    final captured =
        verify(() => repository.upsert(captureAny())).captured.cast<Transaction>();
    final ids = captured.map((t) => t.id).toSet();
    expect(ids.length, 1);
  });

  test('ocorrências em datas diferentes geram ids diferentes', () async {
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));

    await useCase(
      recurrenceRuleId: 'r1',
      accountId: 'a1',
      occurrenceDate: DateOnly(2026, 8, 5),
      amountCents: -1,
      description: 'x',
    );
    await useCase(
      recurrenceRuleId: 'r1',
      accountId: 'a1',
      occurrenceDate: DateOnly(2026, 9, 5),
      amountCents: -1,
      description: 'x',
    );

    final captured =
        verify(() => repository.upsert(captureAny())).captured.cast<Transaction>();
    final ids = captured.map((t) => t.id).toSet();
    expect(ids.length, 2);
  });
}
