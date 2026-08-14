import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../credit_cards/domain/repositories/credit_card_repository.dart';
import '../../../reserves/domain/repositories/reserve_repository.dart';
import '../../../transactions/domain/repositories/recurrence_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/account_snapshot.dart';
import '../entities/daily_balance.dart';
import '../project_cashflow.dart';

/// Junta os 5 repositórios com a engine pura (docs/ROADMAP.md #010):
/// busca tudo que `projectCashflow` precisa e chama a função. É a única
/// peça desta feature que faz I/O — a engine em si continua sem tocar em
/// repositório nenhum.
@injectable
class GetDailyProjection {
  GetDailyProjection(
    this._accounts,
    this._transactions,
    this._recurrences,
    this._creditCards,
    this._reserves,
  );

  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final RecurrenceRepository _recurrences;
  final CreditCardRepository _creditCards;
  final ReserveRepository _reserves;

  Future<Either<Failure, List<DailyBalance>>> call({
    required DateOnly horizonStart,
    required DateOnly horizonEnd,
  }) {
    return guardDatabase(() async {
      final accounts = await _unwrap(_accounts.getAll());
      final transactions = await _unwrap(_transactions.getAll());
      final recurrenceRules = await _unwrap(_recurrences.getAll());
      final creditCards = await _unwrap(_creditCards.getAllCards());
      final invoices = await _unwrap(_creditCards.getAllInvoices());
      final invoiceItems = await _unwrap(_creditCards.getAllItems());
      final reserves = await _unwrap(_reserves.getAll());

      return projectCashflow(
        accounts: accounts.map(_toSnapshot).toList(),
        transactions: transactions,
        recurrenceRules: recurrenceRules,
        creditCards: creditCards,
        invoices: invoices,
        invoiceItems: invoiceItems,
        reserves: reserves,
        horizonStart: horizonStart,
        horizonEnd: horizonEnd,
      );
    });
  }

  AccountSnapshot _toSnapshot(Account account) => AccountSnapshot(
        id: account.id,
        initialBalanceCents: account.initialBalanceCents,
        initialBalanceDate: account.initialBalanceDate,
        archived: account.archived,
      );
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
