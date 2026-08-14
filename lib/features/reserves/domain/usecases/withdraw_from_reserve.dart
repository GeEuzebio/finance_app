import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../repositories/reserve_repository.dart';

/// Resgate de reserva: decrementa `currentAmountCents`. Também não gera
/// `Transaction` — é o espelho de `ContributeToReserve`, o dinheiro nunca
/// saiu de fato, só deixou de estar "etiquetado".
@injectable
class WithdrawFromReserve {
  WithdrawFromReserve(this._repository);

  final ReserveRepository _repository;

  Future<Either<Failure, Unit>> call({
    required String reserveId,
    required int amountCents,
  }) {
    return guardDatabase(() async {
      if (amountCents <= 0) {
        throw const ValidationFailure('amountCents do resgate deve ser positivo');
      }
      final reserve = await _unwrap(_repository.getById(reserveId));
      final newAmount = reserve.currentAmountCents - amountCents;
      if (newAmount < 0) {
        throw const ValidationFailure('Resgate maior que o saldo da reserva');
      }
      final updated = reserve.copyWith(currentAmountCents: newAmount);
      await _unwrap(_repository.upsert(updated));
      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
