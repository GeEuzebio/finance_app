import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/date_only.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'recurrence_override_id.dart';

/// Editar 1 ocorrência de uma série: gera/atualiza uma Transaction
/// concreta vinculada à regra, sem tocar na RecurrenceRule
/// (docs/CASHFLOW_ENGINE.md §3). Não muda a data da ocorrência — a engine
/// casa o override pelo par (recurrenceRuleId, date) original
/// (project_cashflow.dart, passo 2); mudar a data é adiamento, fora do
/// escopo desta issue.
@injectable
class EditSingleOccurrence {
  EditSingleOccurrence(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call({
    required String recurrenceRuleId,
    required String accountId,
    required DateOnly occurrenceDate,
    required int amountCents,
    required String description,
  }) {
    final id = recurrenceOverrideId(recurrenceRuleId, occurrenceDate);
    final now = DateTime.now();
    final transaction = Transaction(
      id: id,
      accountId: accountId,
      description: description,
      amountCents: amountCents,
      date: occurrenceDate,
      status: TransactionStatus.ajustado,
      recurrenceRuleId: recurrenceRuleId,
      createdAt: now,
      updatedAt: now,
    );
    return _repository.upsert(transaction);
  }
}
