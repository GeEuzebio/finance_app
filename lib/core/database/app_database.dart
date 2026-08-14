import 'package:drift/drift.dart';

import '../../features/accounts/domain/entities/account.dart'
    show AccountOwner, AccountType;
import '../../features/credit_cards/domain/entities/invoice.dart'
    show InvoiceStatus;
import '../../features/transactions/domain/entities/recurrence_rule.dart'
    show RecurrenceFrequency;
import '../../features/transactions/domain/entities/transaction.dart'
    show TransactionStatus;
import 'daos/accounts_dao.dart';
import 'daos/credit_cards_dao.dart';
import 'daos/invoice_items_dao.dart';
import 'daos/invoices_dao.dart';
import 'daos/recurrence_rules_dao.dart';
import 'daos/reserves_dao.dart';
import 'daos/transactions_dao.dart';
import 'tables/accounts_table.dart';
import 'tables/credit_cards_table.dart';
import 'tables/invoice_items_table.dart';
import 'tables/invoices_table.dart';
import 'tables/recurrence_rules_table.dart';
import 'tables/reserves_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Transactions,
    RecurrenceRules,
    CreditCards,
    Invoices,
    InvoiceItems,
    Reserves,
  ],
  daos: [
    AccountsDao,
    TransactionsDao,
    RecurrenceRulesDao,
    CreditCardsDao,
    InvoicesDao,
    InvoiceItemsDao,
    ReservesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.connection);

  @override
  int get schemaVersion => 1;

  // schemaVersion 1 = criação inicial (drift cria todas as tabelas
  // automaticamente, sem step de onUpgrade). Versões futuras que alterarem
  // o schema devem incrementar schemaVersion e adicionar um case em
  // MigrationStrategy.onUpgrade (docs/ARCHITECTURE.md §5) — nunca editar
  // uma migration já publicada.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
