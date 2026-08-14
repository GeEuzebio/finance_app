import 'package:drift/drift.dart';

import '../../../features/accounts/domain/entities/account.dart'
    show AccountType, AccountOwner;

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<AccountType>()();
  IntColumn get owner => intEnum<AccountOwner>()();
  IntColumn get initialBalanceCents => integer()();
  DateTimeColumn get initialBalanceDate => dateTime()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
