import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/recurrence_rule.dart';

/// Validações de escrita citadas em docs/CASHFLOW_ENGINE.md §3 como "fora
/// do escopo da engine" — compartilhada por todo caso de uso que cria ou
/// substitui uma RecurrenceRule (create, editar série inteira, a nova
/// regra de um split).
Either<Failure, Unit> validateRecurrenceRule(RecurrenceRule rule) {
  if (rule.endDate != null && rule.occurrenceCount != null) {
    return const Left(ValidationFailure(
      'RecurrenceRule não pode ter endDate e occurrenceCount ao mesmo tempo',
    ));
  }
  if (rule.interval < 1) {
    return const Left(ValidationFailure('RecurrenceRule.interval deve ser >= 1'));
  }
  if (rule.endDate != null && rule.endDate!.isBefore(rule.startDate)) {
    return const Left(
      ValidationFailure('RecurrenceRule.endDate não pode ser antes de startDate'),
    );
  }
  return const Right(unit);
}
