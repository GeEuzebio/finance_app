import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/create_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late CreateTransaction useCase;

  Transaction buildTransaction({String description = 'Salário', int amountCents = 500000}) =>
      Transaction(
        id: 't1',
        accountId: 'a1',
        description: description,
        amountCents: amountCents,
        date: DateOnly(2026, 8, 14),
        status: TransactionStatus.previsto,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  setUpAll(() => registerFallbackValue(buildTransaction()));

  setUp(() {
    repository = _MockTransactionRepository();
    useCase = CreateTransaction(repository);
  });

  test('lançamento válido é persistido via repository.upsert', () async {
    final transaction = buildTransaction();
    when(() => repository.upsert(transaction)).thenAnswer((_) async => const Right(unit));

    final result = await useCase(transaction);

    expect(result.isRight(), isTrue);
    verify(() => repository.upsert(transaction)).called(1);
  });

  test('rejeita amountCents zero sem chamar o repositório', () async {
    final result = await useCase(buildTransaction(amountCents: 0));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });

  test('rejeita description vazia sem chamar o repositório', () async {
    final result = await useCase(buildTransaction(description: ''));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });
}
