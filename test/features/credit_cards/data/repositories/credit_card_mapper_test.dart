import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/data/repositories/credit_card_repository_impl.dart';
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creditCardFromJson(creditCardToJson(x)) faz roundtrip', () {
    final card = CreditCard(
      id: 'c1',
      name: 'Cartão',
      paymentAccountId: 'a1',
      closingDay: 10,
      dueDay: 20,
      limitCents: 500000,
      owner: AccountOwner.eu,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    expect(creditCardFromJson(creditCardToJson(card)), card);
  });

  test('invoiceFromJson(invoiceToJson(x)) faz roundtrip', () {
    final invoice = Invoice(
      id: 'i1',
      creditCardId: 'c1',
      referenceMonth: '2026-03',
      closingDate: DateOnly(2026, 3, 10),
      dueDate: DateOnly(2026, 3, 20),
      status: InvoiceStatus.aberta,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    expect(invoiceFromJson(invoiceToJson(invoice)), invoice);
  });

  test('invoiceItemFromJson(invoiceItemToJson(x)) faz roundtrip', () {
    final item = InvoiceItem(
      id: 'item1',
      invoiceId: 'i1',
      description: 'compra parcelada',
      amountCents: -3334,
      purchaseDate: DateOnly(2026, 5, 1),
      installmentNumber: 1,
      installmentTotal: 3,
      purchaseGroupId: 'g1',
      category: TransactionCategory.transporte,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    final json = invoiceItemToJson(item);
    expect(json['category'], 'transporte');
    expect(invoiceItemFromJson(json), item);
  });
}
