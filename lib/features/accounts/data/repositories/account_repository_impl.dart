import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/accounts_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._dao);

  final AccountsDao _dao;

  @override
  Future<Either<Failure, List<Account>>> getAll() {
    return guardDatabase(() async {
      final rows = await _dao.getAll();
      return rows.map(_toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Account>> getById(String id) {
    return guardDatabase(() async {
      final row = await _dao.getById(id);
      if (row == null) throw NotFoundFailure('Conta $id não encontrada');
      return _toEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Account account) {
    return guardDatabase(() async {
      await _dao.upsert(_toCompanion(account));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) {
    return guardDatabase(() async {
      await _dao.deleteById(id);
      return unit;
    });
  }

  Account _toEntity(db.Account row) => Account(
        id: row.id,
        name: row.name,
        type: row.type,
        owner: row.owner,
        initialBalanceCents: row.initialBalanceCents,
        initialBalanceDate: DateOnly.fromDateTime(row.initialBalanceDate),
        archived: row.archived,
        createdAt: row.createdAt,
      );

  db.AccountsCompanion _toCompanion(Account account) => db.AccountsCompanion.insert(
        id: account.id,
        name: account.name,
        type: account.type,
        owner: account.owner,
        initialBalanceCents: account.initialBalanceCents,
        initialBalanceDate: account.initialBalanceDate.toDateTime(),
        archived: Value(account.archived),
        createdAt: account.createdAt,
      );
}
