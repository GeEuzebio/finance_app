import 'package:drift/drift.dart';

import '../../../features/accounts/domain/entities/account.dart'
    show AccountOwner;
import 'accounts_table.dart';

class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get paymentAccountId => text().references(Accounts, #id)();
  IntColumn get closingDay => integer()();
  IntColumn get dueDay => integer()();
  IntColumn get limitCents => integer().nullable()();
  IntColumn get owner => intEnum<AccountOwner>()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
