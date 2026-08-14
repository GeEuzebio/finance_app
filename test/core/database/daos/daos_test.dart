import 'package:drift/drift.dart' hide isNull;
import 'package:finance_app/core/database/app_database.dart';
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart'
    show AccountOwner, AccountType;
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart'
    show InvoiceStatus;
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart'
    show RecurrenceFrequency;
import 'package:finance_app/features/transactions/domain/entities/transaction.dart'
    show TransactionStatus;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(openTestConnection()));
  tearDown(() => db.close());

  Future<void> insertAccount(String id) => db.accountsDao.upsert(
        AccountsCompanion.insert(
          id: id,
          name: 'Conta $id',
          type: AccountType.checking,
          owner: AccountOwner.eu,
          initialBalanceCents: 100000,
          initialBalanceDate: DateTime(2026, 1, 1),
          createdAt: DateTime(2026, 1, 1),
        ),
      );

  Future<void> insertCard(String id, String paymentAccountId) => db.creditCardsDao.upsert(
        CreditCardsCompanion.insert(
          id: id,
          name: 'Cartão $id',
          paymentAccountId: paymentAccountId,
          closingDay: 10,
          dueDay: 20,
          owner: AccountOwner.eu,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

  Future<void> insertInvoice(String id, String creditCardId) => db.invoicesDao.upsert(
        InvoicesCompanion.insert(
          id: id,
          creditCardId: creditCardId,
          referenceMonth: '2026-03',
          closingDate: DateTime(2026, 3, 10),
          dueDate: DateTime(2026, 3, 20),
          status: InvoiceStatus.aberta,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

  test('AccountsDao — insert, update, query e delete', () async {
    await insertAccount('a1');
    expect((await db.accountsDao.getById('a1'))?.name, 'Conta a1');

    await db.accountsDao.upsert(
      AccountsCompanion.insert(
        id: 'a1',
        name: 'Conta renomeada',
        type: AccountType.checking,
        owner: AccountOwner.eu,
        initialBalanceCents: 100000,
        initialBalanceDate: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect((await db.accountsDao.getById('a1'))?.name, 'Conta renomeada');
    expect((await db.accountsDao.getAll()).length, 1);

    await db.accountsDao.deleteById('a1');
    expect(await db.accountsDao.getById('a1'), isNull);
  });

  test('TransactionsDao — insert, update, query e delete', () async {
    await insertAccount('a1');
    final companion = TransactionsCompanion.insert(
      id: 't1',
      accountId: 'a1',
      description: 'lançamento',
      amountCents: -1000,
      date: DateTime(2026, 8, 1),
      status: TransactionStatus.previsto,
      createdAt: DateTime(2026, 8, 1),
      updatedAt: DateTime(2026, 8, 1),
    );
    await db.transactionsDao.upsert(companion);
    expect((await db.transactionsDao.getById('t1'))?.status, TransactionStatus.previsto);

    await db.transactionsDao.upsert(companion.copyWith(status: const Value(TransactionStatus.confirmado)));
    expect((await db.transactionsDao.getById('t1'))?.status, TransactionStatus.confirmado);
    expect((await db.transactionsDao.getAll()).length, 1);

    await db.transactionsDao.deleteById('t1');
    expect(await db.transactionsDao.getById('t1'), isNull);
  });

  test('RecurrenceRulesDao — insert, update, query e delete', () async {
    await insertAccount('a1');
    final companion = RecurrenceRulesCompanion.insert(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: DateTime(2026, 1, 5),
      createdAt: DateTime(2026, 1, 1),
    );
    await db.recurrenceRulesDao.upsert(companion);
    expect((await db.recurrenceRulesDao.getById('r1'))?.amountCents, -300000);

    await db.recurrenceRulesDao.upsert(companion.copyWith(amountCents: const Value(-320000)));
    expect((await db.recurrenceRulesDao.getById('r1'))?.amountCents, -320000);
    expect((await db.recurrenceRulesDao.getAll()).length, 1);

    await db.recurrenceRulesDao.deleteById('r1');
    expect(await db.recurrenceRulesDao.getById('r1'), isNull);
  });

  test('CreditCardsDao — insert, update, query e delete', () async {
    await insertAccount('a1');
    await insertCard('c1', 'a1');
    expect((await db.creditCardsDao.getById('c1'))?.closingDay, 10);

    await db.creditCardsDao.upsert(
      CreditCardsCompanion.insert(
        id: 'c1',
        name: 'Cartão c1',
        paymentAccountId: 'a1',
        closingDay: 15,
        dueDay: 25,
        owner: AccountOwner.eu,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect((await db.creditCardsDao.getById('c1'))?.closingDay, 15);
    expect((await db.creditCardsDao.getAll()).length, 1);

    await db.creditCardsDao.deleteById('c1');
    expect(await db.creditCardsDao.getById('c1'), isNull);
  });

  test('InvoicesDao — insert, update, query e delete', () async {
    await insertAccount('a1');
    await insertCard('c1', 'a1');
    await insertInvoice('i1', 'c1');
    expect((await db.invoicesDao.getById('i1'))?.status, InvoiceStatus.aberta);

    await db.invoicesDao.upsert(
      InvoicesCompanion.insert(
        id: 'i1',
        creditCardId: 'c1',
        referenceMonth: '2026-03',
        closingDate: DateTime(2026, 3, 10),
        dueDate: DateTime(2026, 3, 20),
        status: InvoiceStatus.paga,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect((await db.invoicesDao.getById('i1'))?.status, InvoiceStatus.paga);
    expect((await db.invoicesDao.getAll()).length, 1);

    await db.invoicesDao.deleteById('i1');
    expect(await db.invoicesDao.getById('i1'), isNull);
  });

  test('InvoiceItemsDao — insert, update, query, delete e soma agregada', () async {
    await insertAccount('a1');
    await insertCard('c1', 'a1');
    await insertInvoice('i1', 'c1');

    await db.invoiceItemsDao.upsert(
      InvoiceItemsCompanion.insert(
        id: 'item1',
        invoiceId: 'i1',
        description: 'compra',
        amountCents: -8000,
        purchaseDate: DateTime(2026, 3, 3),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    await db.invoiceItemsDao.upsert(
      InvoiceItemsCompanion.insert(
        id: 'item2',
        invoiceId: 'i1',
        description: 'outra compra',
        amountCents: -2000,
        purchaseDate: DateTime(2026, 3, 4),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g2',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    expect((await db.invoiceItemsDao.getForInvoice('i1')).length, 2);
    expect(await db.invoiceItemsDao.totalCentsForInvoice('i1'), -10000);

    // estorno da primeira compra — reduz o total agregado
    await db.invoiceItemsDao.upsert(
      InvoiceItemsCompanion.insert(
        id: 'item3',
        invoiceId: 'i1',
        description: 'estorno',
        amountCents: 8000,
        purchaseDate: DateTime(2026, 3, 5),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect(await db.invoiceItemsDao.totalCentsForInvoice('i1'), -2000);

    await db.invoiceItemsDao.deleteById('item2');
    // restam item1 (-8000) e o estorno item3 (+8000) — soma zerada
    expect(await db.invoiceItemsDao.totalCentsForInvoice('i1'), 0);
    expect(await db.invoiceItemsDao.getById('item2'), isNull);
  });

  test('ReservesDao — insert, update, query e delete', () async {
    await db.reservesDao.upsert(
      ReservesCompanion.insert(
        id: 'r1',
        name: 'Emergência',
        currentAmountCents: 50000,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect((await db.reservesDao.getById('r1'))?.currentAmountCents, 50000);

    await db.reservesDao.upsert(
      ReservesCompanion.insert(
        id: 'r1',
        name: 'Emergência',
        currentAmountCents: 70000,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    expect((await db.reservesDao.getById('r1'))?.currentAmountCents, 70000);
    expect((await db.reservesDao.getAll()).length, 1);

    await db.reservesDao.deleteById('r1');
    expect(await db.reservesDao.getById('r1'), isNull);
  });
}
