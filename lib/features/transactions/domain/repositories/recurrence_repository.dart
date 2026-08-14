import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/recurrence_rule.dart';

abstract class RecurrenceRepository {
  Future<Either<Failure, List<RecurrenceRule>>> getAll();
  Future<Either<Failure, RecurrenceRule>> getById(String id);
  Future<Either<Failure, Unit>> upsert(RecurrenceRule rule);
  Future<Either<Failure, Unit>> delete(String id);
}
