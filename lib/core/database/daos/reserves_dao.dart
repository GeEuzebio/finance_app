import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/reserves_table.dart';

part 'reserves_dao.g.dart';

@DriftAccessor(tables: [Reserves])
class ReservesDao extends DatabaseAccessor<AppDatabase> with _$ReservesDaoMixin {
  ReservesDao(super.db);

  Future<List<Reserve>> getAll() => select(reserves).get();

  Future<Reserve?> getById(String id) =>
      (select(reserves)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ReservesCompanion entry) =>
      into(reserves).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(reserves)..where((r) => r.id.equals(id))).go();
}
