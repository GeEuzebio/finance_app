import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/recurrence_rule.dart';
import '../../domain/repositories/recurrence_repository.dart';

const _table = 'recurrence_rules';

@LazySingleton(as: RecurrenceRepository)
class RecurrenceRepositoryImpl implements RecurrenceRepository {
  RecurrenceRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<RecurrenceRule>>> getAll() {
    return guardDatabase(() async {
      final rows = await _client.from(_table).select();
      return rows.map(recurrenceRuleFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, RecurrenceRule>> getById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Regra de recorrência $id não encontrada');
      return recurrenceRuleFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(RecurrenceRule rule) {
    return guardDatabase(() async {
      await _client.from(_table).upsert(recurrenceRuleToJson(rule));
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

RecurrenceRule recurrenceRuleFromJson(Map<String, dynamic> row) => RecurrenceRule(
      id: row['id'] as String,
      accountId: row['account_id'] as String,
      description: row['description'] as String,
      amountCents: row['amount_cents'] as int,
      frequency: RecurrenceFrequency.values.byName(row['frequency'] as String),
      interval: row['recurrence_interval'] as int,
      startDate: DateOnly.fromDateTime(DateTime.parse(row['start_date'] as String)),
      endDate: row['end_date'] == null
          ? null
          : DateOnly.fromDateTime(DateTime.parse(row['end_date'] as String)),
      occurrenceCount: row['occurrence_count'] as int?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> recurrenceRuleToJson(RecurrenceRule rule) => {
      'id': rule.id,
      'account_id': rule.accountId,
      'description': rule.description,
      'amount_cents': rule.amountCents,
      'frequency': rule.frequency.name,
      'recurrence_interval': rule.interval,
      'start_date': rule.startDate.toDateTime().toIso8601String().split('T').first,
      'end_date': rule.endDate?.toDateTime().toIso8601String().split('T').first,
      'occurrence_count': rule.occurrenceCount,
      'created_at': rule.createdAt.toIso8601String(),
    };
