import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/recurrence_rules_table.dart';

part 'recurrence_rules_dao.g.dart';

@DriftAccessor(tables: [RecurrenceRules])
class RecurrenceRulesDao extends DatabaseAccessor<AppDatabase>
    with _$RecurrenceRulesDaoMixin {
  RecurrenceRulesDao(super.db);

  Future<List<RecurrenceRule>> getAll() => select(recurrenceRules).get();

  Future<RecurrenceRule?> getById(String id) =>
      (select(recurrenceRules)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<void> upsert(RecurrenceRulesCompanion entry) =>
      into(recurrenceRules).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(recurrenceRules)..where((r) => r.id.equals(id))).go();
}
