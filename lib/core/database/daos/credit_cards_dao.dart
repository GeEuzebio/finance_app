import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/credit_cards_table.dart';

part 'credit_cards_dao.g.dart';

@DriftAccessor(tables: [CreditCards])
class CreditCardsDao extends DatabaseAccessor<AppDatabase>
    with _$CreditCardsDaoMixin {
  CreditCardsDao(super.db);

  Future<List<CreditCard>> getAll() => select(creditCards).get();

  Future<CreditCard?> getById(String id) =>
      (select(creditCards)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(CreditCardsCompanion entry) =>
      into(creditCards).insertOnConflictUpdate(entry);

  Future<void> deleteById(String id) =>
      (delete(creditCards)..where((c) => c.id.equals(id))).go();
}
