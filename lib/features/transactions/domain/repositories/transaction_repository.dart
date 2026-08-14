import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getAll();
  Future<Either<Failure, Transaction>> getById(String id);
  Future<Either<Failure, Unit>> upsert(Transaction transaction);
  Future<Either<Failure, Unit>> delete(String id);
}
