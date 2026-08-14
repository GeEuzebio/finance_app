import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/find_or_create_invoice.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/reverse_invoice_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

class _MockFindOrCreateInvoice extends Mock implements FindOrCreateInvoice {}

void main() {
  late _MockCreditCardRepository repository;
  late _MockFindOrCreateInvoice findOrCreateInvoice;
  late ReverseInvoiceItem useCase;

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
    id: 'inv-sep',
    creditCardId: 'c1',
    referenceMonth: '2026-09',
    closingDate: DateOnly(2026, 9, 10),
    dueDate: DateOnly(2026, 9, 20),
    status: InvoiceStatus.aberta,
    createdAt: DateTime(2026),
  );
  final originalItem = InvoiceItem(
    id: 'item1',
    invoiceId: 'inv-sep',
    description: 'compra',
    amountCents: -8000,
    purchaseDate: DateOnly(2026, 9, 3),
    installmentNumber: 1,
    installmentTotal: 1,
    purchaseGroupId: 'g1',
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
    useCase = ReverseInvoiceItem(repository, findOrCreateInvoice);

    when(() => repository.getInvoiceById('inv-sep')).thenAnswer((_) async => Right(invoice));
    when(() => repository.getCardById('c1')).thenAnswer((_) async => Right(card));
    when(() => findOrCreateInvoice(
          card: any(named: 'card'),
          referenceDate: any(named: 'referenceDate'),
        )).thenAnswer((_) async => Right(invoice));
    when(() => repository.upsertItem(any())).thenAnswer((_) async => const Right(unit));
  });

  test('cria item de estorno com sinal invertido e mesmo purchaseGroupId', () async {
    final result = await useCase(originalItem: originalItem, reversalDate: DateOnly(2026, 9, 5));

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => repository.upsertItem(captureAny())).captured.single as InvoiceItem;
    expect(captured.amountCents, 8000);
    expect(captured.purchaseGroupId, 'g1');
    expect(captured.invoiceId, 'inv-sep');
  });
}
