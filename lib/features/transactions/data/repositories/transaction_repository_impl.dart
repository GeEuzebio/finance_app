import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

const _table = 'transactions';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<Transaction>>> getAll() {
    return guardDatabase(() async {
      final rows = await _client.from(_table).select();
      return rows.map(transactionFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Transaction>> getById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Lançamento $id não encontrado');
      return transactionFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Transaction transaction) {
    return guardDatabase(() async {
      await _client.from(_table).upsert(transactionToJson(transaction));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) {
    return guardDatabase(() async {
      await _client.from(_table).delete().eq('id', id);
      return unit;
    });
  }
}

Transaction transactionFromJson(Map<String, dynamic> row) => Transaction(
      id: row['id'] as String,
      accountId: row['account_id'] as String,
      description: row['description'] as String,
      amountCents: row['amount_cents'] as int,
      date: DateOnly.fromDateTime(DateTime.parse(row['date'] as String)),
      status: TransactionStatus.values.byName(row['status'] as String),
      recurrenceRuleId: row['recurrence_rule_id'] as String?,
      originalTransactionId: row['original_transaction_id'] as String?,
      transferGroupId: row['transfer_group_id'] as String?,
      invoicePaymentForId: row['invoice_payment_for_id'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );

Map<String, dynamic> transactionToJson(Transaction transaction) => {
      'id': transaction.id,
      'account_id': transaction.accountId,
      'description': transaction.description,
      'amount_cents': transaction.amountCents,
      'date': transaction.date.toDateTime().toIso8601String().split('T').first,
      'status': transaction.status.name,
      'recurrence_rule_id': transaction.recurrenceRuleId,
      'original_transaction_id': transaction.originalTransactionId,
      'transfer_group_id': transaction.transferGroupId,
      'invoice_payment_for_id': transaction.invoicePaymentForId,
      'created_at': transaction.createdAt.toIso8601String(),
      'updated_at': transaction.updatedAt.toIso8601String(),
    };
