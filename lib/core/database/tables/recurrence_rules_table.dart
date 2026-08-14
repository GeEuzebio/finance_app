import 'package:drift/drift.dart';

import '../../../features/transactions/domain/entities/recurrence_rule.dart'
    show RecurrenceFrequency;
import 'accounts_table.dart';

class RecurrenceRules extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  IntColumn get frequency => intEnum<RecurrenceFrequency>()();
  IntColumn get interval => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get occurrenceCount => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
