import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/parsed_transaction.dart';

typedef ImportResult = ({int imported, int skipped});

/// Persiste lançamentos já parseados de um OFX/CSV (M7, #023),
/// deduplicando contra `Transaction.externalId` — reimportar o mesmo
/// período não cria linha duplicada, só ignora (`skipped`) o que já
/// existe.
@injectable
class ImportTransactions {
  ImportTransactions(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, ImportResult>> call({
    required String accountId,
    required List<ParsedTransaction> parsed,
  }) {
    return guardDatabase(() async {
      final existing = await _unwrap(_repository.getAll());
      final existingIds = existing.map((t) => t.externalId).whereType<String>().toSet();

      var imported = 0;
      var skipped = 0;
      for (final row in parsed) {
        if (existingIds.contains(row.externalId)) {
          skipped++;
          continue;
        }
        final now = DateTime.now();
        await _unwrap(_repository.upsert(Transaction(
          id: const Uuid().v4(),
          accountId: accountId,
          description: row.description,
          amountCents: row.amountCents,
          date: row.date,
          status: TransactionStatus.confirmado,
          externalId: row.externalId,
          createdAt: now,
          updatedAt: now,
        )));
        imported++;
      }
      return (imported: imported, skipped: skipped);
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
