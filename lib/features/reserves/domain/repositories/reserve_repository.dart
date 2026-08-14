import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/reserve.dart';

abstract class ReserveRepository {
  Future<Either<Failure, List<Reserve>>> getAll();
  Future<Either<Failure, Reserve>> getById(String id);
  Future<Either<Failure, Unit>> upsert(Reserve reserve);
  Future<Either<Failure, Unit>> delete(String id);
}
