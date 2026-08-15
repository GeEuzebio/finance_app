import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/get_committed_card_balance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

void main() {
  late _MockCreditCardRepository repository;
  late GetCommittedCardBalance useCase;

  Invoice buildInvoice(String id, InvoiceStatus status) => Invoice(
        id: id,
        creditCardId: 'c1',
        referenceMonth: '2026-08',
        closingDate: DateOnly(2026, 8, 25),
        dueDate: DateOnly(2026, 9, 5),
        status: status,
        createdAt: DateTime(2026),
      );

  InvoiceItem buildItem(String invoiceId, int amountCents) => InvoiceItem(
        id: 'i-$invoiceId-$amountCents',
        invoiceId: invoiceId,
        description: 'compra',
        amountCents: amountCents,
        purchaseDate: DateOnly(2026, 8, 10),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        createdAt: DateTime(2026),
      );

  setUp(() {
    repository = _MockCreditCardRepository();
    useCase = GetCommittedCardBalance(repository);
  });

  test('soma itens só das faturas não pagas (aberta/fechada)', () async {
    when(() => repository.getAllInvoices()).thenAnswer((_) async => Right([
          buildInvoice('aberta1', InvoiceStatus.aberta),
          buildInvoice('fechada1', InvoiceStatus.fechada),
          buildInvoice('paga1', InvoiceStatus.paga),
        ]));
    when(() => repository.getAllItems()).thenAnswer((_) async => Right([
          buildItem('aberta1', -10000),
          buildItem('fechada1', -20000),
          buildItem('paga1', -99999),
        ]));

    final result = await useCase();

    result.match((l) => fail('esperava Right'), (total) => expect(total, -30000));
  });

  test('devolve 0 sem consultar itens quando não há fatura em aberto', () async {
    when(() => repository.getAllInvoices())
        .thenAnswer((_) async => Right([buildInvoice('paga1', InvoiceStatus.paga)]));

    final result = await useCase();

    result.match((l) => fail('esperava Right'), (total) => expect(total, 0));
    verifyNever(() => repository.getAllItems());
  });
}
