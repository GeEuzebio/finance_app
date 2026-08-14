import 'package:finance_app/core/database/app_database.dart';
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart'
    show TransactionStatus;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(openTestConnection()));
  tearDown(() => db.close());

  test('abre em memória e fecha sem erro', () {
    expect(db.schemaVersion, 1);
  });

  test('cria as 7 tabelas de domínio', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();

    expect(
      names.containsAll({
        'accounts',
        'transactions',
        'recurrence_rules',
        'credit_cards',
        'invoices',
        'invoice_items',
        'reserves',
      }),
      isTrue,
    );
  });

  test('rejeita insert com foreign key inválida', () async {
    expect(
      () => db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              id: 't1',
              accountId: 'conta-inexistente',
              description: 'teste',
              amountCents: -1000,
              date: DateTime(2026, 1, 1),
              status: TransactionStatus.previsto,
              createdAt: DateTime(2026, 1, 1),
              updatedAt: DateTime(2026, 1, 1),
            ),
          ),
      throwsException,
    );
  });
}
