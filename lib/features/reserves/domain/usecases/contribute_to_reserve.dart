import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../repositories/reserve_repository.dart';

/// Aporte em reserva é movimentação interna, não despesa — só incrementa
/// `currentAmountCents`, nunca gera `Transaction` (docs/CASHFLOW_ENGINE.md
/// §3, Reservas). Só depende de `ReserveRepository`, então não tem como
/// tocar em `Transaction` nenhuma por construção.
@injectable
class ContributeToReserve {
  ContributeToReserve(this._repository);

  final ReserveRepository _repository;

  Future<Either<Failure, Unit>> call({
    required String reserveId,
    required int amountCents,
  }) {
    return guardDatabase(() async {
      if (amountCents <= 0) {
        throw const ValidationFailure('amountCents do aporte deve ser positivo');
      }
      final reserve = await _unwrap(_repository.getById(reserveId));
      final updated = reserve.copyWith(
        currentAmountCents: reserve.currentAmountCents + amountCents,
      );
      await _unwrap(_repository.upsert(updated));
      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
