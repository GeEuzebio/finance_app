import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future<List<Transaction>> getAll() => select(transactions).get();

  Future<Transaction?> getById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(TransactionsCompanion entry) =>
      into(transactions).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();
}
