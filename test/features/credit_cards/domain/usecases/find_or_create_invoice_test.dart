import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/find_or_create_invoice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

void main() {
  late _MockCreditCardRepository repository;
  late FindOrCreateInvoice useCase;

  final card = CreditCard(
    id: 'c1',
    name: 'Cartão',
    paymentAccountId: 'a1',
    closingDay: 10,
    dueDay: 20,
    owner: AccountOwner.eu,
    createdAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(
      Invoice(
        id: 'fallback',
        creditCardId: 'c1',
        referenceMonth: '2026-01',
        closingDate: DateOnly(2026, 1, 10),
        dueDate: DateOnly(2026, 1, 20),
        status: InvoiceStatus.aberta,
        createdAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    repository = _MockCreditCardRepository();
    useCase = FindOrCreateInvoice(repository);
  });

  test('reaproveita fatura existente em vez de criar outra', () async {
    final existing = Invoice(
      id: 'existing',
      creditCardId: 'c1',
      referenceMonth: '2026-03',
      closingDate: DateOnly(2026, 3, 10),
      dueDate: DateOnly(2026, 3, 20),
      status: InvoiceStatus.aberta,
      createdAt: DateTime(2026),
    );
    when(() => repository.getAllInvoices()).thenAnswer((_) async => Right([existing]));

    final result = await useCase(card: card, referenceDate: DateOnly(2026, 3, 5));

    result.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.id, 'existing'));
    verifyNever(() => repository.upsertInvoice(any()));
  });

  test('compra no dia exato do fechamento cai na fatura atual, não na seguinte', () async {
    when(() => repository.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => repository.upsertInvoice(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(card: card, referenceDate: DateOnly(2026, 3, 10));

    result.match(
      (l) => fail('esperava Right, recebeu $l'),
      (r) => expect(r.referenceMonth, '2026-03'),
    );
  });

  test('cria fatura nova com dueDate no mesmo mês quando dueDay >= closingDay', () async {
    when(() => repository.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => repository.upsertInvoice(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(card: card, referenceDate: DateOnly(2026, 3, 5));

    result.match(
      (l) => fail('esperava Right, recebeu $l'),
      (r) {
        expect(r.closingDate, DateOnly(2026, 3, 10));
        expect(r.dueDate, DateOnly(2026, 3, 20));
      },
    );
  });

  test('dueDate cai no mês seguinte quando dueDay < closingDay', () async {
    final cardWithRollover = CreditCard(
      id: 'c2',
      name: 'Cartão 2',
      paymentAccountId: 'a1',
      closingDay: 25,
      dueDay: 5,
      owner: AccountOwner.eu,
      createdAt: DateTime(2026),
    );
    when(() => repository.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => repository.upsertInvoice(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(card: cardWithRollover, referenceDate: DateOnly(2026, 3, 5));

    result.match(
      (l) => fail('esperava Right, recebeu $l'),
      (r) => expect(r.dueDate, DateOnly(2026, 4, 5)),
    );
  });
}
