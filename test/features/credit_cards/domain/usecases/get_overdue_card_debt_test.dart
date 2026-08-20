import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/get_overdue_card_debt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

void main() {
  late _MockCreditCardRepository repository;
  late GetOverdueCardDebt useCase;

  final today = DateOnly(2026, 8, 14);

  Invoice buildInvoice(String id, InvoiceStatus status, DateOnly dueDate) => Invoice(
        id: id,
        creditCardId: 'c1',
        referenceMonth: '2026-07',
        closingDate: dueDate.addDays(-10),
        dueDate: dueDate,
        status: status,
        createdAt: DateTime(2026),
      );

  InvoiceItem buildItem(String invoiceId, int amountCents) => InvoiceItem(
        id: 'i-$invoiceId-$amountCents',
        invoiceId: invoiceId,
        description: 'compra',
        amountCents: amountCents,
        purchaseDate: DateOnly(2026, 7, 10),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        createdAt: DateTime(2026),
      );

  setUp(() {
    repository = _MockCreditCardRepository();
    useCase = GetOverdueCardDebt(repository);
  });

  test('soma só faturas vencidas e não pagas, ignora fatura aberta que ainda não venceu',
      () async {
    when(() => repository.getAllInvoices()).thenAnswer((_) async => Right([
          buildInvoice('atrasada1', InvoiceStatus.fechada, DateOnly(2026, 8, 1)),
          buildInvoice('futura1', InvoiceStatus.aberta, DateOnly(2026, 9, 5)),
          buildInvoice('paga1', InvoiceStatus.paga, DateOnly(2026, 7, 5)),
        ]));
    when(() => repository.getAllItems()).thenAnswer((_) async => Right([
          buildItem('atrasada1', -50000),
          buildItem('futura1', -30000),
          buildItem('paga1', -99999),
        ]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right'), (total) => expect(total, -50000));
  });

  test('devolve 0 sem consultar itens quando não há fatura atrasada', () async {
    when(() => repository.getAllInvoices()).thenAnswer(
      (_) async => Right([buildInvoice('futura1', InvoiceStatus.aberta, DateOnly(2026, 9, 5))]),
    );

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right'), (total) => expect(total, 0));
    verifyNever(() => repository.getAllItems());
  });
}
