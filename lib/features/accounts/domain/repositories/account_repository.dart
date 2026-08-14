import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<Account>>> getAll();
  Future<Either<Failure, Account>> getById(String id);
  Future<Either<Failure, Unit>> upsert(Account account);
  Future<Either<Failure, Unit>> delete(String id);
}
