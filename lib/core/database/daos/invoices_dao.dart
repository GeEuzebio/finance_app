import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/invoices_table.dart';

part 'invoices_dao.g.dart';

@DriftAccessor(tables: [Invoices])
class InvoicesDao extends DatabaseAccessor<AppDatabase> with _$InvoicesDaoMixin {
  InvoicesDao(super.db);

  Future<List<Invoice>> getAll() => select(invoices).get();

  Future<Invoice?> getById(String id) =>
      (select(invoices)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<void> upsert(InvoicesCompanion entry) =>
      into(invoices).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(invoices)..where((i) => i.id.equals(id))).go();
}
