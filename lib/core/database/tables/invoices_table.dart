import 'package:drift/drift.dart';

import '../../../features/credit_cards/domain/entities/invoice.dart'
    show InvoiceStatus;
import 'credit_cards_table.dart';

class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get creditCardId => text().references(CreditCards, #id)();
  TextColumn get referenceMonth => text()();
  DateTimeColumn get closingDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get status => intEnum<InvoiceStatus>()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  // totalCents não é coluna: é agregado via SUM(amountCents) sobre
  // InvoiceItems (docs/ARCHITECTURE.md §5) — evita dessincronizar do
  // detalhe da fatura em compra nova/estorno.
}
