import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import '../database/connection.dart';
import '../database/daos/accounts_dao.dart';
import '../database/daos/credit_cards_dao.dart';
import '../database/daos/invoice_items_dao.dart';
import '../database/daos/invoices_dao.dart';
import '../database/daos/recurrence_rules_dao.dart';
import '../database/daos/reserves_dao.dart';
import '../database/daos/transactions_dao.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase(openProductionConnection());

  @lazySingleton
  AccountsDao accountsDao(AppDatabase db) => db.accountsDao;

  @lazySingleton
  TransactionsDao transactionsDao(AppDatabase db) => db.transactionsDao;

  @lazySingleton
  RecurrenceRulesDao recurrenceRulesDao(AppDatabase db) => db.recurrenceRulesDao;

  @lazySingleton
  CreditCardsDao creditCardsDao(AppDatabase db) => db.creditCardsDao;

  @lazySingleton
  InvoicesDao invoicesDao(AppDatabase db) => db.invoicesDao;

  @lazySingleton
  InvoiceItemsDao invoiceItemsDao(AppDatabase db) => db.invoiceItemsDao;

  @lazySingleton
  ReservesDao reservesDao(AppDatabase db) => db.reservesDao;
}
