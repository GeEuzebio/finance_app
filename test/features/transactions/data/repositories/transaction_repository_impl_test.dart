import 'package:finance_app/core/database/app_database.dart' hide Transaction;
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart'
    show AccountOwner, AccountType;
import 'package:finance_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(openTestConnection());
    repository = TransactionRepositoryImpl(db.transactionsDao);
  });
  tearDown(() => db.close());

  Transaction buildTransaction(String id, {String accountId = 'a1'}) => Transaction(
        id: id,
        accountId: accountId,
        description: 'lançamento',
        amountCents: -1000,
        date: DateOnly(2026, 8, 1),
        status: TransactionStatus.previsto,
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      );

  test('upsert + getAll + getById + delete via Right, com conta válida', () async {
    await db.accountsDao.upsert(
      AccountsCompanion.insert(
        id: 'a1',
        name: 'Conta a1',
        type: AccountType.checking,
        owner: AccountOwner.eu,
        initialBalanceCents: 100000,
        initialBalanceDate: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final upsertResult = await repository.upsert(buildTransaction('t1'));
    expect(upsertResult.isRight(), isTrue);

    final all = await repository.getAll();
    all.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.single.id, 't1'));

    final deleteResult = await repository.delete('t1');
    expect(deleteResult.isRight(), isTrue);
  });

  test('getById em id inexistente devolve Left(NotFoundFailure)', () async {
    final result = await repository.getById('não-existe');

    result.match(
      (l) => expect(l, isA<NotFoundFailure>()),
      (r) => fail('esperava Left(NotFoundFailure)'),
    );
  });

  test('violação de foreign key vira Left(DatabaseFailure), nunca escapa como throw', () async {
    // nenhuma conta 'inexistente' foi criada — a FK deve rejeitar o insert
    final result = await repository.upsert(buildTransaction('t1', accountId: 'inexistente'));

    expect(result.isLeft(), isTrue);
    result.match(
      (l) => expect(l, isA<DatabaseFailure>()),
      (r) => fail('esperava Left(DatabaseFailure)'),
    );
  });
}
