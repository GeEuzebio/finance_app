import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/recurrence_rule.dart';
import '../repositories/recurrence_repository.dart';
import 'recurrence_rule_validation.dart';

/// Editar toda a série: atualiza a RecurrenceRule in-place. Nunca altera
/// Transactions já confirmado/ajustado (docs/CASHFLOW_ENGINE.md §3) — este
/// caso de uso não toca em Transaction nenhuma, só na regra.
@injectable
class EditWholeSeries {
  EditWholeSeries(this._repository);

  final RecurrenceRepository _repository;

  Future<Either<Failure, Unit>> call(RecurrenceRule updatedRule) {
    final validation = validateRecurrenceRule(updatedRule);
    if (validation.isLeft()) return Future.value(validation);
    return _repository.upsert(updatedRule);
  }
}
