import 'package:finance_app/core/database/app_database.dart' hide Account;
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AccountRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(openTestConnection());
    repository = AccountRepositoryImpl(db.accountsDao);
  });
  tearDown(() => db.close());

  Account buildAccount(String id) => Account(
        id: id,
        name: 'Conta $id',
        type: AccountType.checking,
        owner: AccountOwner.eu,
        initialBalanceCents: 100000,
        initialBalanceDate: DateOnly(2026, 1, 1),
        archived: false,
        createdAt: DateTime(2026, 1, 1),
      );

  test('upsert + getAll + getById devolvem Right com a entidade mapeada', () async {
    final upsertResult = await repository.upsert(buildAccount('a1'));
    expect(upsertResult.isRight(), isTrue);

    final all = await repository.getAll();
    all.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.single.id, 'a1'));

    final byId = await repository.getById('a1');
    byId.match(
      (l) => fail('esperava Right, recebeu $l'),
      (r) => expect(r.name, 'Conta a1'),
    );
  });

  test('getById em id inexistente devolve Left(NotFoundFailure)', () async {
    final result = await repository.getById('não-existe');

    expect(result.isLeft(), isTrue);
    result.match(
      (l) => expect(l, isA<NotFoundFailure>()),
      (r) => fail('esperava Left(NotFoundFailure)'),
    );
  });

  test('delete remove a conta', () async {
    await repository.upsert(buildAccount('a1'));

    final deleteResult = await repository.delete('a1');
    expect(deleteResult.isRight(), isTrue);

    final result = await repository.getById('a1');
    expect(result.isLeft(), isTrue);
  });
}
