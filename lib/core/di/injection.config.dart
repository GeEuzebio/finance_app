// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finance_app/core/di/injection.dart' as _i806;
import 'package:finance_app/features/accounts/data/repositories/account_repository_impl.dart'
    as _i913;
import 'package:finance_app/features/accounts/domain/repositories/account_repository.dart'
    as _i161;
import 'package:finance_app/features/cashflow_engine/domain/usecases/get_daily_projection.dart'
    as _i669;
import 'package:finance_app/features/cashflow_engine/domain/usecases/get_monthly_summary.dart'
    as _i903;
import 'package:finance_app/features/credit_cards/data/repositories/credit_card_repository_impl.dart'
    as _i737;
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart'
    as _i947;
import 'package:finance_app/features/credit_cards/domain/usecases/find_or_create_invoice.dart'
    as _i485;
import 'package:finance_app/features/credit_cards/domain/usecases/get_committed_card_balance.dart'
    as _i659;
import 'package:finance_app/features/credit_cards/domain/usecases/import_invoice_items.dart'
    as _i871;
import 'package:finance_app/features/credit_cards/domain/usecases/pay_invoice.dart'
    as _i918;
import 'package:finance_app/features/credit_cards/domain/usecases/register_card_purchase.dart'
    as _i735;
import 'package:finance_app/features/credit_cards/domain/usecases/reverse_invoice_item.dart'
    as _i53;
import 'package:finance_app/features/imports/domain/usecases/import_transactions.dart'
    as _i792;
import 'package:finance_app/features/notifications/notification_service.dart'
    as _i551;
import 'package:finance_app/features/reserves/data/repositories/reserve_repository_impl.dart'
    as _i365;
import 'package:finance_app/features/reserves/domain/repositories/reserve_repository.dart'
    as _i1073;
import 'package:finance_app/features/reserves/domain/usecases/contribute_to_reserve.dart'
    as _i333;
import 'package:finance_app/features/reserves/domain/usecases/create_reserve.dart'
    as _i825;
import 'package:finance_app/features/reserves/domain/usecases/withdraw_from_reserve.dart'
    as _i911;
import 'package:finance_app/features/transactions/data/repositories/recurrence_repository_impl.dart'
    as _i468;
import 'package:finance_app/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i755;
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart'
    as _i12;
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart'
    as _i958;
import 'package:finance_app/features/transactions/domain/usecases/adjust_check_in_item.dart'
    as _i603;
import 'package:finance_app/features/transactions/domain/usecases/cancel_check_in_item.dart'
    as _i27;
import 'package:finance_app/features/transactions/domain/usecases/confirm_check_in_item.dart'
    as _i636;
import 'package:finance_app/features/transactions/domain/usecases/create_recurrence_rule.dart'
    as _i584;
import 'package:finance_app/features/transactions/domain/usecases/create_transaction.dart'
    as _i117;
import 'package:finance_app/features/transactions/domain/usecases/edit_recurrence_from_date.dart'
    as _i977;
import 'package:finance_app/features/transactions/domain/usecases/edit_single_occurrence.dart'
    as _i618;
import 'package:finance_app/features/transactions/domain/usecases/edit_whole_series.dart'
    as _i247;
import 'package:finance_app/features/transactions/domain/usecases/get_day_ledger.dart'
    as _i663;
import 'package:finance_app/features/transactions/domain/usecases/get_today_check_in_items.dart'
    as _i231;
import 'package:finance_app/features/transactions/domain/usecases/postpone_check_in_item.dart'
    as _i378;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

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
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
        () => registerModule.notificationsPlugin);
    gh.lazySingleton<_i551.NotificationService>(() =>
        _i551.NotificationService(gh<_i163.FlutterLocalNotificationsPlugin>()));
    gh.lazySingleton<_i1073.ReserveRepository>(
        () => _i365.ReserveRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i161.AccountRepository>(
        () => _i913.AccountRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i911.WithdrawFromReserve>(
        () => _i911.WithdrawFromReserve(gh<_i1073.ReserveRepository>()));
    gh.factory<_i825.CreateReserve>(
        () => _i825.CreateReserve(gh<_i1073.ReserveRepository>()));
    gh.factory<_i333.ContributeToReserve>(
        () => _i333.ContributeToReserve(gh<_i1073.ReserveRepository>()));
    gh.lazySingleton<_i958.TransactionRepository>(
        () => _i755.TransactionRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i947.CreditCardRepository>(
        () => _i737.CreditCardRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i12.RecurrenceRepository>(
        () => _i468.RecurrenceRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i663.GetDayLedger>(() => _i663.GetDayLedger(
          gh<_i161.AccountRepository>(),
          gh<_i958.TransactionRepository>(),
          gh<_i12.RecurrenceRepository>(),
          gh<_i947.CreditCardRepository>(),
        ));
    gh.factory<_i792.ImportTransactions>(
        () => _i792.ImportTransactions(gh<_i958.TransactionRepository>()));
    gh.factory<_i117.CreateTransaction>(
        () => _i117.CreateTransaction(gh<_i958.TransactionRepository>()));
    gh.factory<_i618.EditSingleOccurrence>(
        () => _i618.EditSingleOccurrence(gh<_i958.TransactionRepository>()));
    gh.factory<_i27.CancelCheckInItem>(
        () => _i27.CancelCheckInItem(gh<_i958.TransactionRepository>()));
    gh.factory<_i636.ConfirmCheckInItem>(
        () => _i636.ConfirmCheckInItem(gh<_i958.TransactionRepository>()));
    gh.factory<_i378.PostponeCheckInItem>(
        () => _i378.PostponeCheckInItem(gh<_i958.TransactionRepository>()));
    gh.factory<_i603.AdjustCheckInItem>(
        () => _i603.AdjustCheckInItem(gh<_i958.TransactionRepository>()));
    gh.factory<_i903.GetMonthlySummary>(() => _i903.GetMonthlySummary(
          gh<_i958.TransactionRepository>(),
          gh<_i12.RecurrenceRepository>(),
          gh<_i947.CreditCardRepository>(),
        ));
    gh.factory<_i231.GetTodayCheckInItems>(() => _i231.GetTodayCheckInItems(
          gh<_i161.AccountRepository>(),
          gh<_i958.TransactionRepository>(),
          gh<_i12.RecurrenceRepository>(),
        ));
    gh.factory<_i918.PayInvoice>(() => _i918.PayInvoice(
          gh<_i947.CreditCardRepository>(),
          gh<_i958.TransactionRepository>(),
        ));
    gh.factory<_i669.GetDailyProjection>(() => _i669.GetDailyProjection(
          gh<_i161.AccountRepository>(),
          gh<_i958.TransactionRepository>(),
          gh<_i12.RecurrenceRepository>(),
          gh<_i947.CreditCardRepository>(),
          gh<_i1073.ReserveRepository>(),
        ));
    gh.factory<_i584.CreateRecurrenceRule>(
        () => _i584.CreateRecurrenceRule(gh<_i12.RecurrenceRepository>()));
    gh.factory<_i977.EditRecurrenceFromDate>(
        () => _i977.EditRecurrenceFromDate(gh<_i12.RecurrenceRepository>()));
    gh.factory<_i247.EditWholeSeries>(
        () => _i247.EditWholeSeries(gh<_i12.RecurrenceRepository>()));
    gh.factory<_i659.GetCommittedCardBalance>(
        () => _i659.GetCommittedCardBalance(gh<_i947.CreditCardRepository>()));
    gh.factory<_i485.FindOrCreateInvoice>(
        () => _i485.FindOrCreateInvoice(gh<_i947.CreditCardRepository>()));
    gh.factory<_i871.ImportInvoiceItems>(() => _i871.ImportInvoiceItems(
          gh<_i947.CreditCardRepository>(),
          gh<_i485.FindOrCreateInvoice>(),
        ));
    gh.factory<_i53.ReverseInvoiceItem>(() => _i53.ReverseInvoiceItem(
          gh<_i947.CreditCardRepository>(),
          gh<_i485.FindOrCreateInvoice>(),
        ));
    gh.factory<_i735.RegisterCardPurchase>(() => _i735.RegisterCardPurchase(
          gh<_i947.CreditCardRepository>(),
          gh<_i485.FindOrCreateInvoice>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i806.RegisterModule {}
