import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/find_or_create_invoice.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/import_invoice_items.dart';
import 'package:finance_app/features/imports/domain/entities/parsed_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

class _MockFindOrCreateInvoice extends Mock implements FindOrCreateInvoice {}

void main() {
  late _MockCreditCardRepository repository;
  late _MockFindOrCreateInvoice findOrCreateInvoice;
  late ImportInvoiceItems useCase;

  final card = CreditCard(
    id: 'c1',
    name: 'Cartão',
    paymentAccountId: 'a1',
    closingDay: 10,
    dueDay: 20,
    owner: AccountOwner.eu,
    createdAt: DateTime(2026),
  );

  final invoice = Invoice(
    id: 'inv-1',
    creditCardId: 'c1',
    referenceMonth: '2026-8',
    closingDate: DateOnly(2026, 8, 10),
    dueDate: DateOnly(2026, 8, 20),
    status: InvoiceStatus.aberta,
    createdAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(
      InvoiceItem(
        id: 'fallback',
        invoiceId: 'inv',
        description: 'x',
        amountCents: 0,
        purchaseDate: DateOnly(2026, 1, 1),
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g',
        createdAt: DateTime(2026),
      ),
    );
    registerFallbackValue(card);
    registerFallbackValue(DateOnly(2026, 1, 1));
  });

  setUp(() {
    repository = _MockCreditCardRepository();
    findOrCreateInvoice = _MockFindOrCreateInvoice();
    useCase = ImportInvoiceItems(repository, findOrCreateInvoice);

    when(() => repository.getCardById('c1')).thenAnswer((_) async => Right(card));
    when(() => findOrCreateInvoice(
          card: any(named: 'card'),
          referenceDate: any(named: 'referenceDate'),
        )).thenAnswer((_) async => Right(invoice));
    when(() => repository.upsertItem(any())).thenAnswer((_) async => const Right(unit));
  });

  test('importa itens novos como 1x na fatura certa', () async {
    when(() => repository.getAllItems()).thenAnswer((_) async => const Right([]));

    final result = await useCase(
      creditCardId: 'c1',
      parsed: [
        ParsedTransaction(
          date: DateOnly(2026, 8, 5),
          description: 'Supermercado',
          amountCents: -12000,
          externalId: 'ofx:1',
        ),
      ],
    );

    expect(result.isRight(), isTrue);
    result.match((l) => fail('esperava Right'), (r) {
      expect(r.imported, 1);
      expect(r.skipped, 0);
    });
    final captured =
        verify(() => repository.upsertItem(captureAny())).captured.single as InvoiceItem;
    expect(captured.invoiceId, 'inv-1');
    expect(captured.amountCents, -12000);
    expect(captured.installmentNumber, 1);
    expect(captured.installmentTotal, 1);
    expect(captured.externalId, 'ofx:1');
  });

  test('pula item cujo externalId já existe', () async {
    when(() => repository.getAllItems()).thenAnswer((_) async => Right([
          InvoiceItem(
            id: 'i1',
            invoiceId: 'inv-1',
            description: 'Supermercado',
            amountCents: -12000,
            purchaseDate: DateOnly(2026, 8, 5),
            installmentNumber: 1,
            installmentTotal: 1,
            purchaseGroupId: 'g1',
            externalId: 'ofx:1',
            createdAt: DateTime(2026),
          ),
        ]));

    final result = await useCase(
      creditCardId: 'c1',
      parsed: [
        ParsedTransaction(
          date: DateOnly(2026, 8, 5),
          description: 'Supermercado',
          amountCents: -12000,
          externalId: 'ofx:1',
        ),
      ],
    );

    result.match((l) => fail('esperava Right'), (r) {
      expect(r.imported, 0);
      expect(r.skipped, 1);
    });
    verifyNever(() => repository.upsertItem(any()));
    verifyNever(() => findOrCreateInvoice(
          card: any(named: 'card'),
          referenceDate: any(named: 'referenceDate'),
        ));
  });
}
