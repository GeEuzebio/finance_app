import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'materialize_check_in_item.dart';

/// Adiar: a ocorrência original sai da soma na data original (status
/// `adiado`) e uma nova ocorrência `previsto` nasce em [newDate], apontando
/// de volta via `originalTransactionId` (docs/CASHFLOW_ENGINE.md §3).
@injectable
class PostponeCheckInItem {
  PostponeCheckInItem(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call(CheckInItem item, {required DateOnly newDate}) {
    return guardDatabase(() async {
      final original = materializeCheckInItem(item, status: TransactionStatus.adiado);
      await _unwrap(_repository.upsert(original));

      final now = DateTime.now();
      final postponed = Transaction(
        id: const Uuid().v4(),
        accountId: item.accountId,
        description: item.description,
        amountCents: item.amountCents,
        date: newDate,
        status: TransactionStatus.previsto,
        category: item.category,
        originalTransactionId: original.id,
        createdAt: now,
        updatedAt: now,
      );
      await _unwrap(_repository.upsert(postponed));
      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
