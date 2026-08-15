import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

@injectable
class CreateTransaction {
  CreateTransaction(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call(Transaction transaction) {
    if (transaction.description.isEmpty) {
      return Future.value(const Left(ValidationFailure('description não pode ser vazia')));
    }
    if (transaction.amountCents == 0) {
      return Future.value(const Left(ValidationFailure('amountCents não pode ser zero')));
    }
    return _repository.upsert(transaction);
  }
}
