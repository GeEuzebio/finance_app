import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'materialize_check_in_item.dart';

/// Cancelar: sai da soma da projeção, mas o registro fica pra histórico
/// (soft-delete via status — docs/CASHFLOW_ENGINE.md §3).
@injectable
class CancelCheckInItem {
  CancelCheckInItem(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call(CheckInItem item) {
    return _repository.upsert(
      materializeCheckInItem(item, status: TransactionStatus.cancelado),
    );
  }
}
