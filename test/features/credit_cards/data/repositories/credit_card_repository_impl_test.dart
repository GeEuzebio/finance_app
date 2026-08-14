import 'package:finance_app/core/database/app_database.dart'
    hide CreditCard, Invoice, InvoiceItem;
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart'
    show AccountOwner, AccountType;
import 'package:finance_app/features/credit_cards/data/repositories/credit_card_repository_impl.dart';
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CreditCardRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(openTestConnection());
    repository = CreditCardRepositoryImpl(
      db.creditCardsDao,
      db.invoicesDao,
      db.invoiceItemsDao,
    );
    await db.accountsDao.upsert(
      AccountsCompanion.insert(
        id: 'a1',
        name: 'Conta a1',
        type: AccountType.checking,
        owner: AccountOwner.eu,
        initialBalanceCents: 100000,
        initialBalanceDate: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  });
  tearDown(() => db.close());

  test('cartão, fatura e itens via Either, com soma agregada', () async {
    final card = CreditCard(
      id: 'c1',
      name: 'Cartão',
      paymentAccountId: 'a1',
      closingDay: 10,
      dueDay: 20,
      owner: AccountOwner.eu,
      createdAt: DateTime(2026, 1, 1),
    );
    expect((await repository.upsertCard(card)).isRight(), isTrue);

    final invoice = Invoice(
      id: 'i1',
      creditCardId: 'c1',
      referenceMonth: '2026-03',
      closingDate: DateOnly(2026, 3, 10),
      dueDate: DateOnly(2026, 3, 20),
      status: InvoiceStatus.aberta,
      createdAt: DateTime(2026, 1, 1),
    );
    expect((await repository.upsertInvoice(invoice)).isRight(), isTrue);

    final item = InvoiceItem(
      id: 'item1',
      invoiceId: 'i1',
      description: 'compra',
      amountCents: -8000,
      purchaseDate: DateOnly(2026, 3, 3),
      installmentNumber: 1,
      installmentTotal: 1,
      purchaseGroupId: 'g1',
      createdAt: DateTime(2026, 1, 1),
    );
    expect((await repository.upsertItem(item)).isRight(), isTrue);

    final items = await repository.getItemsForInvoice('i1');
    items.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.single.id, 'item1'));

    final total = await repository.totalCentsForInvoice('i1');
    total.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r, -8000));

    final cardById = await repository.getCardById('c1');
    cardById.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.closingDay, 10));
  });
}
