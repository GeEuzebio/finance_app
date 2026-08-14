import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/date_only.dart';
import '../entities/recurrence_rule.dart';
import '../repositories/recurrence_repository.dart';
import 'recurrence_rule_validation.dart';

/// Editar "esta e as futuras" — split simples (ADR 0004): a regra atual
/// recebe endDate no dia anterior a [fromDate], e uma regra nova nasce a
/// partir de [fromDate] com os novos parâmetros. Nenhuma tabela de
/// histórico — a regra antiga simplesmente para de gerar ocorrências.
@injectable
class EditRecurrenceFromDate {
  EditRecurrenceFromDate(this._repository);

  final RecurrenceRepository _repository;

  Future<Either<Failure, Unit>> call({
    required RecurrenceRule currentRule,
    required DateOnly fromDate,
    required int newAmountCents,
    required RecurrenceFrequency newFrequency,
    required int newInterval,
    DateOnly? newEndDate,
    int? newOccurrenceCount,
  }) async {
    final newRule = RecurrenceRule(
      id: const Uuid().v4(),
      accountId: currentRule.accountId,
      description: currentRule.description,
      amountCents: newAmountCents,
      frequency: newFrequency,
      interval: newInterval,
      startDate: fromDate,
      endDate: newEndDate,
      occurrenceCount: newOccurrenceCount,
      createdAt: DateTime.now(),
    );
    final validation = validateRecurrenceRule(newRule);
    if (validation.isLeft()) return validation;

    // occurrenceCount zerado: depois do split, quem governa o fim da
    // regra fechada é sempre a data, nunca mais a contagem original
    // (evita violar a exclusividade mútua que validateRecurrenceRule exige).
    final closedRule = currentRule.copyWith(
      endDate: fromDate.addDays(-1),
      occurrenceCount: null,
    );

    // ponytail: dois upserts sequenciais, sem transação — o Supabase via
    // PostgREST não expõe transação multi-tabela sem uma função RPC
    // dedicada. Se um dia isso morder (falha entre os dois upserts
    // deixando estado parcial), a saída é uma função Postgres com as duas
    // escritas atômicas.
    final closeResult = await _repository.upsert(closedRule);
    if (closeResult.isLeft()) return closeResult;
    return _repository.upsert(newRule);
  }
}
