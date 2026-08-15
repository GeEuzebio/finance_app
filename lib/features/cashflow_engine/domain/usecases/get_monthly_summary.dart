import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../credit_cards/domain/repositories/credit_card_repository.dart';
import '../../../transactions/domain/repositories/recurrence_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/monthly_summary.dart';
import '../monthly_summary.dart';

/// Junta os repositórios com `summarizeMonth` (docs/ROADMAP.md #021) —
/// mesmo padrão de `GetDailyProjection`, só que com as 3 dependências que
/// a função realmente usa.
@injectable
class GetMonthlySummary {
  GetMonthlySummary(this._transactions, this._recurrences, this._creditCards);

  final TransactionRepository _transactions;
  final RecurrenceRepository _recurrences;
  final CreditCardRepository _creditCards;

  Future<Either<Failure, MonthlySummary>> call({
    required int year,
    required int month,
    required int savingsTargetPercent,
  }) {
    return guardDatabase(() async {
      final transactions = await _unwrap(_transactions.getAll());
      final recurrenceRules = await _unwrap(_recurrences.getAll());
      final invoiceItems = await _unwrap(_creditCards.getAllItems());

      return summarizeMonth(
        transactions: transactions,
        recurrenceRules: recurrenceRules,
        invoiceItems: invoiceItems,
        year: year,
        month: month,
        savingsTargetPercent: savingsTargetPercent,
        today: DateOnly.fromDateTime(DateTime.now()),
      );
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
