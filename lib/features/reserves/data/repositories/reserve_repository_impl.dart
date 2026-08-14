import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/reserves_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../domain/entities/reserve.dart';
import '../../domain/repositories/reserve_repository.dart';

@LazySingleton(as: ReserveRepository)
class ReserveRepositoryImpl implements ReserveRepository {
  ReserveRepositoryImpl(this._dao);

  final ReservesDao _dao;

  @override
  Future<Either<Failure, List<Reserve>>> getAll() {
    return guardDatabase(() async {
      final rows = await _dao.getAll();
      return rows.map(_toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Reserve>> getById(String id) {
    return guardDatabase(() async {
      final row = await _dao.getById(id);
      if (row == null) throw NotFoundFailure('Reserva $id não encontrada');
      return _toEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Reserve reserve) {
    return guardDatabase(() async {
      await _dao.upsert(_toCompanion(reserve));
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

  Reserve _toEntity(db.Reserve row) => Reserve(
        id: row.id,
        name: row.name,
        targetAmountCents: row.targetAmountCents,
        currentAmountCents: row.currentAmountCents,
        createdAt: row.createdAt,
      );

  db.ReservesCompanion _toCompanion(Reserve reserve) => db.ReservesCompanion.insert(
        id: reserve.id,
        name: reserve.name,
        targetAmountCents: Value(reserve.targetAmountCents),
        currentAmountCents: reserve.currentAmountCents,
        createdAt: reserve.createdAt,
      );
}
