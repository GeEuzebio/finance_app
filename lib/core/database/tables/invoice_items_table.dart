import 'package:drift/drift.dart';

import 'invoices_table.dart';

class InvoiceItems extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceId => text().references(Invoices, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get installmentNumber => integer()();
  IntColumn get installmentTotal => integer()();
  TextColumn get purchaseGroupId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
