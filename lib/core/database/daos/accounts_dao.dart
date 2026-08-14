import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<List<Account>> getAll() => select(accounts).get();

  Future<Account?> getById(String id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<void> upsert(AccountsCompanion entry) =>
      into(accounts).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(accounts)..where((a) => a.id.equals(id))).go();
}
