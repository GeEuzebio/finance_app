import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/reserve.dart';
import '../repositories/reserve_repository.dart';

@injectable
class CreateReserve {
  CreateReserve(this._repository);

  final ReserveRepository _repository;

  Future<Either<Failure, Unit>> call(Reserve reserve) {
    if (reserve.currentAmountCents < 0) {
      return Future.value(
        const Left(ValidationFailure('currentAmountCents não pode ser negativo')),
      );
    }
    if ((reserve.targetAmountCents ?? 0) < 0) {
      return Future.value(
        const Left(ValidationFailure('targetAmountCents não pode ser negativo')),
      );
    }
    return _repository.upsert(reserve);
  }
}
