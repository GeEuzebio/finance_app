import 'package:drift/drift.dart';

class Reserves extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get targetAmountCents => integer().nullable()();
  IntColumn get currentAmountCents => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
