import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/invoice_items_table.dart';

part 'invoice_items_dao.g.dart';

@DriftAccessor(tables: [InvoiceItems])
class InvoiceItemsDao extends DatabaseAccessor<AppDatabase>
    with _$InvoiceItemsDaoMixin {
  InvoiceItemsDao(super.db);

  Future<List<InvoiceItem>> getAll() => select(invoiceItems).get();

  Future<List<InvoiceItem>> getForInvoice(String invoiceId) =>
      (select(invoiceItems)..where((i) => i.invoiceId.equals(invoiceId))).get();

  Future<InvoiceItem?> getById(String id) =>
      (select(invoiceItems)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<void> upsert(InvoiceItemsCompanion entry) =>
      into(invoiceItems).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(invoiceItems)..where((i) => i.id.equals(id))).go();

  /// Soma de `amountCents` de todos os itens da fatura — usada como
  /// `Invoice.totalCents` (docs/ARCHITECTURE.md §5: não é uma coluna
  /// persistida, sempre agregada a partir do detalhe).
  Future<int> totalCentsForInvoice(String invoiceId) async {
    final sumAmount = invoiceItems.amountCents.sum();
    final query = selectOnly(invoiceItems)
      ..addColumns([sumAmount])
      ..where(invoiceItems.invoiceId.equals(invoiceId));
    final row = await query.getSingle();
    return row.read(sumAmount) ?? 0;
  }
}
