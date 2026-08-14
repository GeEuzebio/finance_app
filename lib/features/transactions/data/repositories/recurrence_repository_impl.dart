import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/recurrence_rules_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/recurrence_rule.dart';
import '../../domain/repositories/recurrence_repository.dart';

@LazySingleton(as: RecurrenceRepository)
class RecurrenceRepositoryImpl implements RecurrenceRepository {
  RecurrenceRepositoryImpl(this._dao);

  final RecurrenceRulesDao _dao;

  @override
  Future<Either<Failure, List<RecurrenceRule>>> getAll() {
    return guardDatabase(() async {
      final rows = await _dao.getAll();
      return rows.map(_toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, RecurrenceRule>> getById(String id) {
    return guardDatabase(() async {
      final row = await _dao.getById(id);
      if (row == null) throw NotFoundFailure('Regra de recorrência $id não encontrada');
      return _toEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(RecurrenceRule rule) {
    return guardDatabase(() async {
      await _dao.upsert(_toCompanion(rule));
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

  RecurrenceRule _toEntity(db.RecurrenceRule row) => RecurrenceRule(
        id: row.id,
        accountId: row.accountId,
        description: row.description,
        amountCents: row.amountCents,
        frequency: row.frequency,
        interval: row.interval,
        startDate: DateOnly.fromDateTime(row.startDate),
        endDate: row.endDate == null ? null : DateOnly.fromDateTime(row.endDate!),
        occurrenceCount: row.occurrenceCount,
        createdAt: row.createdAt,
      );

  db.RecurrenceRulesCompanion _toCompanion(RecurrenceRule rule) =>
      db.RecurrenceRulesCompanion.insert(
        id: rule.id,
        accountId: rule.accountId,
        description: rule.description,
        amountCents: rule.amountCents,
        frequency: rule.frequency,
        interval: rule.interval,
        startDate: rule.startDate.toDateTime(),
        endDate: Value(rule.endDate?.toDateTime()),
        occurrenceCount: Value(rule.occurrenceCount),
        createdAt: rule.createdAt,
      );
}
