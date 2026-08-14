import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'materialize_check_in_item.dart';

/// Ajustar: "aconteceu, mas com valor diferente do previsto" — mesma data.
@injectable
class AdjustCheckInItem {
  AdjustCheckInItem(this._repository);

  final TransactionRepository _repository;

  Future<Either<Failure, Unit>> call(CheckInItem item, {required int newAmountCents}) {
    return _repository.upsert(
      materializeCheckInItem(item, status: TransactionStatus.ajustado, amountCents: newAmountCents),
    );
  }
}
