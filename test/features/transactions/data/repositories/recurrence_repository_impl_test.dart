import 'package:finance_app/core/database/app_database.dart' hide RecurrenceRule;
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart'
    show AccountOwner, AccountType;
import 'package:finance_app/features/transactions/data/repositories/recurrence_repository_impl.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late RecurrenceRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(openTestConnection());
    repository = RecurrenceRepositoryImpl(db.recurrenceRulesDao);
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
  });
  tearDown(() => db.close());

  RecurrenceRule buildRule(String id) => RecurrenceRule(
        id: id,
        accountId: 'a1',
        description: 'aluguel',
        amountCents: -300000,
        frequency: RecurrenceFrequency.monthly,
        interval: 1,
        startDate: DateOnly(2026, 1, 5),
        createdAt: DateTime(2026, 1, 1),
      );

  test('upsert + getAll + getById + delete roundtrip via Either', () async {
    expect((await repository.upsert(buildRule('r1'))).isRight(), isTrue);

    final all = await repository.getAll();
    all.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.single.id, 'r1'));

    final byId = await repository.getById('r1');
    byId.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.amountCents, -300000));

    expect((await repository.delete('r1')).isRight(), isTrue);
    final afterDelete = await repository.getById('r1');
    afterDelete.match((l) => expect(l, isA<NotFoundFailure>()), (r) => fail('esperava Left'));
  });
}
