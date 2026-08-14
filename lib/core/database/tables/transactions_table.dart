import 'package:drift/drift.dart';

import '../../../features/transactions/domain/entities/transaction.dart'
    show TransactionStatus;
import 'accounts_table.dart';
import 'invoices_table.dart';
import 'recurrence_rules_table.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get status => intEnum<TransactionStatus>()();
  TextColumn get recurrenceRuleId =>
      text().nullable().references(RecurrenceRules, #id)();
  TextColumn get originalTransactionId => text().nullable()();
  TextColumn get transferGroupId => text().nullable()();
  TextColumn get invoicePaymentForId =>
      text().nullable().references(Invoices, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
