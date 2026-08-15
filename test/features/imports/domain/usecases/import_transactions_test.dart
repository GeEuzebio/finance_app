import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/imports/domain/entities/parsed_transaction.dart';
import 'package:finance_app/features/imports/domain/usecases/import_transactions.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late ImportTransactions useCase;

  setUpAll(() => registerFallbackValue(
        Transaction(
          id: 'fallback',
          accountId: 'a',
          description: 'x',
          amountCents: 0,
          date: DateOnly(2026, 1, 1),
          status: TransactionStatus.confirmado,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ));

  setUp(() {
    repository = _MockTransactionRepository();
    useCase = ImportTransactions(repository);
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));
  });

  test('importa lançamentos novos e persiste com status confirmado', () async {
    when(() => repository.getAll()).thenAnswer((_) async => const Right([]));

    final result = await useCase(
      accountId: 'a1',
      parsed: [
        ParsedTransaction(
          date: DateOnly(2026, 8, 10),
          description: 'Mercado',
          amountCents: -15000,
          externalId: 'ofx:1',
        ),
      ],
    );

    expect(result.isRight(), isTrue);
    result.match((l) => fail('esperava Right'), (r) {
      expect(r.imported, 1);
      expect(r.skipped, 0);
    });
    final captured = verify(() => repository.upsert(captureAny())).captured.single as Transaction;
    expect(captured.status, TransactionStatus.confirmado);
    expect(captured.externalId, 'ofx:1');
    expect(captured.accountId, 'a1');
  });

  test('pula lançamento cujo externalId já existe', () async {
    when(() => repository.getAll()).thenAnswer((_) async => Right([
          Transaction(
            id: 't1',
            accountId: 'a1',
            description: 'Mercado',
            amountCents: -15000,
            date: DateOnly(2026, 8, 10),
            status: TransactionStatus.confirmado,
            externalId: 'ofx:1',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ]));

    final result = await useCase(
      accountId: 'a1',
      parsed: [
        ParsedTransaction(
          date: DateOnly(2026, 8, 10),
          description: 'Mercado',
          amountCents: -15000,
          externalId: 'ofx:1',
        ),
      ],
    );

    result.match((l) => fail('esperava Right'), (r) {
      expect(r.imported, 0);
      expect(r.skipped, 1);
    });
    verifyNever(() => repository.upsert(any()));
  });
}
