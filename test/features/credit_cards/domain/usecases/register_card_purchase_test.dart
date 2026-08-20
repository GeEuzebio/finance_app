import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/find_or_create_invoice.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/register_card_purchase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

class _MockFindOrCreateInvoice extends Mock implements FindOrCreateInvoice {}

void main() {
  late _MockCreditCardRepository repository;
  late _MockFindOrCreateInvoice findOrCreateInvoice;
  late RegisterCardPurchase useCase;

  final card = CreditCard(
    id: 'c1',
    name: 'Cartão',
    paymentAccountId: 'a1',
    closingDay: 10,
    dueDay: 20,
    owner: AccountOwner.eu,
    createdAt: DateTime(2026),
  );

  Invoice invoiceFor(DateOnly date) => Invoice(
        id: 'inv-${date.year}-${date.month}',
        creditCardId: 'c1',
        referenceMonth: '${date.year}-${date.month}',
        closingDate: date,
        dueDate: date,
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
    useCase = RegisterCardPurchase(repository, findOrCreateInvoice);

    when(() => repository.getCardById('c1')).thenAnswer((_) async => Right(card));
    when(() => findOrCreateInvoice(
          card: any(named: 'card'),
          referenceDate: any(named: 'referenceDate'),
        )).thenAnswer((invocation) async {
      final date = invocation.namedArguments[#referenceDate] as DateOnly;
      return Right(invoiceFor(date));
    });
    when(() => repository.upsertItem(any())).thenAnswer((_) async => const Right(unit));
  });

  test('compra em 3x de R\$100,00 gera parcelas -3334/-3333/-3333 em 3 faturas', () async {
    final result = await useCase(
      creditCardId: 'c1',
      description: 'compra parcelada',
      totalAmountCents: -10000,
      purchaseDate: DateOnly(2026, 5, 1),
      installments: 3,
      category: TransactionCategory.outros,
    );

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => repository.upsertItem(captureAny())).captured.cast<InvoiceItem>();
    expect(captured.length, 3);
    expect(captured.map((i) => i.amountCents).toList(), [-3334, -3333, -3333]);
    expect(captured.map((i) => i.invoiceId).toSet().length, 3);
    expect(
      captured.every((i) => i.purchaseGroupId == captured.first.purchaseGroupId),
      isTrue,
    );
    expect(captured.map((i) => i.installmentNumber).toList(), [1, 2, 3]);
  });

  test('compra à vista (1x) gera 1 InvoiceItem só', () async {
    await useCase(
      creditCardId: 'c1',
      description: 'compra à vista',
      totalAmountCents: -5000,
      purchaseDate: DateOnly(2026, 5, 1),
      installments: 1,
      category: TransactionCategory.outros,
    );

    final captured =
        verify(() => repository.upsertItem(captureAny())).captured.cast<InvoiceItem>();
    expect(captured.length, 1);
    expect(captured.single.amountCents, -5000);
    expect(captured.single.installmentTotal, 1);
  });

  test('rejeita installments < 1 sem chamar o repositório', () async {
    final result = await useCase(
      creditCardId: 'c1',
      description: 'x',
      totalAmountCents: -1000,
      purchaseDate: DateOnly(2026, 5, 1),
      installments: 0,
      category: TransactionCategory.outros,
    );

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsertItem(any()));
  });
}
