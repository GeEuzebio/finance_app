// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finance_app/core/database/app_database.dart' as _i546;
import 'package:finance_app/core/database/daos/accounts_dao.dart' as _i13;
import 'package:finance_app/core/database/daos/credit_cards_dao.dart' as _i466;
import 'package:finance_app/core/database/daos/invoice_items_dao.dart' as _i999;
import 'package:finance_app/core/database/daos/invoices_dao.dart' as _i186;
import 'package:finance_app/core/database/daos/recurrence_rules_dao.dart'
    as _i334;
import 'package:finance_app/core/database/daos/reserves_dao.dart' as _i436;
import 'package:finance_app/core/database/daos/transactions_dao.dart' as _i602;
import 'package:finance_app/core/di/injection.dart' as _i806;
import 'package:finance_app/features/accounts/data/repositories/account_repository_impl.dart'
    as _i913;
import 'package:finance_app/features/accounts/domain/repositories/account_repository.dart'
    as _i161;
import 'package:finance_app/features/credit_cards/data/repositories/credit_card_repository_impl.dart'
    as _i737;
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart'
    as _i947;
import 'package:finance_app/features/reserves/data/repositories/reserve_repository_impl.dart'
    as _i365;
import 'package:finance_app/features/reserves/domain/repositories/reserve_repository.dart'
    as _i1073;
import 'package:finance_app/features/transactions/data/repositories/recurrence_repository_impl.dart'
    as _i468;
import 'package:finance_app/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i755;
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart'
    as _i12;
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart'
    as _i958;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i546.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i13.AccountsDao>(
        () => registerModule.accountsDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i602.TransactionsDao>(
        () => registerModule.transactionsDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i334.RecurrenceRulesDao>(
        () => registerModule.recurrenceRulesDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i466.CreditCardsDao>(
        () => registerModule.creditCardsDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i186.InvoicesDao>(
        () => registerModule.invoicesDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i999.InvoiceItemsDao>(
        () => registerModule.invoiceItemsDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i436.ReservesDao>(
        () => registerModule.reservesDao(gh<_i546.AppDatabase>()));
    gh.lazySingleton<_i958.TransactionRepository>(
        () => _i755.TransactionRepositoryImpl(gh<_i602.TransactionsDao>()));
    gh.lazySingleton<_i161.AccountRepository>(
        () => _i913.AccountRepositoryImpl(gh<_i13.AccountsDao>()));
    gh.lazySingleton<_i1073.ReserveRepository>(
        () => _i365.ReserveRepositoryImpl(gh<_i436.ReservesDao>()));
    gh.lazySingleton<_i12.RecurrenceRepository>(
        () => _i468.RecurrenceRepositoryImpl(gh<_i334.RecurrenceRulesDao>()));
    gh.lazySingleton<_i947.CreditCardRepository>(
        () => _i737.CreditCardRepositoryImpl(
              gh<_i466.CreditCardsDao>(),
              gh<_i186.InvoicesDao>(),
              gh<_i999.InvoiceItemsDao>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i806.RegisterModule {}
