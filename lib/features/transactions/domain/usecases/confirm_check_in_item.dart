import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'materialize_check_in_item.dart';

/// Confirmar: "aconteceu igual estava previsto" — mesmo valor, mesma data.
@injectable
class ConfirmCheckInItem {
  ConfirmCheckInItem(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call(CheckInItem item) {
    return _repository.upsert(
      materializeCheckInItem(item, status: TransactionStatus.confirmado),
    );
  }
}
