import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/recurrence_rule.dart';
import '../repositories/recurrence_repository.dart';
import 'recurrence_rule_validation.dart';

@injectable
class CreateRecurrenceRule {
  CreateRecurrenceRule(this._repository);

  final RecurrenceRepository _repository;

  Future<Either<Failure, Unit>> call(RecurrenceRule rule) {
    final validation = validateRecurrenceRule(rule);
    if (validation.isLeft()) return Future.value(validation);
    return _repository.upsert(rule);
  }
}
