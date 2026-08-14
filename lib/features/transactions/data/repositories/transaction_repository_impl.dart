import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dao);

  final TransactionsDao _dao;

  @override
  Future<Either<Failure, List<Transaction>>> getAll() {
    return guardDatabase(() async {
      final rows = await _dao.getAll();
      return rows.map(_toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Transaction>> getById(String id) {
    return guardDatabase(() async {
      final row = await _dao.getById(id);
      if (row == null) throw NotFoundFailure('Lançamento $id não encontrado');
      return _toEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Transaction transaction) {
    return guardDatabase(() async {
      await _dao.upsert(_toCompanion(transaction));
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

  Transaction _toEntity(db.Transaction row) => Transaction(
        id: row.id,
        accountId: row.accountId,
        description: row.description,
        amountCents: row.amountCents,
        date: DateOnly.fromDateTime(row.date),
        status: row.status,
        recurrenceRuleId: row.recurrenceRuleId,
        originalTransactionId: row.originalTransactionId,
        transferGroupId: row.transferGroupId,
        invoicePaymentForId: row.invoicePaymentForId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  db.TransactionsCompanion _toCompanion(Transaction transaction) =>
      db.TransactionsCompanion.insert(
        id: transaction.id,
        accountId: transaction.accountId,
        description: transaction.description,
        amountCents: transaction.amountCents,
        date: transaction.date.toDateTime(),
        status: transaction.status,
        recurrenceRuleId: Value(transaction.recurrenceRuleId),
        originalTransactionId: Value(transaction.originalTransactionId),
        transferGroupId: Value(transaction.transferGroupId),
        invoicePaymentForId: Value(transaction.invoicePaymentForId),
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      );
}
