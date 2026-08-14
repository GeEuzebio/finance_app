import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../domain/entities/reserve.dart';
import '../../domain/repositories/reserve_repository.dart';

const _table = 'reserves';

@LazySingleton(as: ReserveRepository)
class ReserveRepositoryImpl implements ReserveRepository {
  ReserveRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<Reserve>>> getAll() {
    return guardDatabase(() async {
      final rows = await _client.from(_table).select();
      return rows.map(reserveFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Reserve>> getById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Reserva $id não encontrada');
      return reserveFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Reserve reserve) {
    return guardDatabase(() async {
      await _client.from(_table).upsert(reserveToJson(reserve));
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

Reserve reserveFromJson(Map<String, dynamic> row) => Reserve(
      id: row['id'] as String,
      name: row['name'] as String,
      targetAmountCents: row['target_amount_cents'] as int?,
      currentAmountCents: row['current_amount_cents'] as int,
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> reserveToJson(Reserve reserve) => {
      'id': reserve.id,
      'name': reserve.name,
      'target_amount_cents': reserve.targetAmountCents,
      'current_amount_cents': reserve.currentAmountCents,
      'created_at': reserve.createdAt.toIso8601String(),
    };
