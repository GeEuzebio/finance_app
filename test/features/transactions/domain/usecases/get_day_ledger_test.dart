import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:finance_app/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/get_day_ledger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockTransactionRepository extends Mock implements TransactionRepository {}

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

void main() {
  late _MockAccountRepository accounts;
  late _MockTransactionRepository transactions;
  late _MockRecurrenceRepository recurrences;
  late _MockCreditCardRepository creditCards;
  late GetDayLedger useCase;

  final day = DateOnly(2026, 8, 14);
  final account = Account(
    id: 'a1',
    name: 'Conta',
    type: AccountType.checking,
    owner: AccountOwner.eu,
    initialBalanceCents: 0,
    initialBalanceDate: day,
    archived: false,
    createdAt: DateTime(2026),
  );

  setUp(() {
    accounts = _MockAccountRepository();
    transactions = _MockTransactionRepository();
    recurrences = _MockRecurrenceRepository();
    creditCards = _MockCreditCardRepository();
    useCase = GetDayLedger(accounts, transactions, recurrences, creditCards);
    when(() => accounts.getAll()).thenAnswer((_) async => Right([account]));
    when(() => recurrences.getAll()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllCards()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllItems()).thenAnswer((_) async => const Right([]));
  });

  test('inclui Transaction confirmada do dia (diferente do check-in, que só pega previsto)',
      () async {
    final t = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'mercado',
      amountCents: -5000,
      date: day,
      status: TransactionStatus.confirmado,
      category: TransactionCategory.alimentacao,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([t]));

    final result = await useCase(day: day);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) {
      expect(items.length, 1);
      expect(items.single.transactionId, 't1');
      expect(items.single.category, TransactionCategory.alimentacao);
    });
  });

  test('exclui Transaction cancelada e adiada do dia', () async {
    final cancelada = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'x',
      amountCents: -1000,
      date: day,
      status: TransactionStatus.cancelado,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    final adiada = Transaction(
      id: 't2',
      accountId: 'a1',
      description: 'y',
      amountCents: -1000,
      date: day,
      status: TransactionStatus.adiado,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([cancelada, adiada]));

    final result = await useCase(day: day);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) => expect(items, isEmpty));
  });

  test('inclui débito sintético de fatura vencendo no dia, quando ainda não paga', () async {
    final card = CreditCard(
      id: 'c1',
      name: 'Cartão',
      paymentAccountId: 'a1',
      closingDay: 10,
      dueDay: 14,
      owner: AccountOwner.eu,
      createdAt: DateTime(2026),
    );
    final invoice = Invoice(
      id: 'inv1',
      creditCardId: 'c1',
      referenceMonth: '2026-8',
      closingDate: DateOnly(2026, 8, 10),
      dueDate: day,
      status: InvoiceStatus.fechada,
      createdAt: DateTime(2026),
    );
    final item = InvoiceItem(
      id: 'i1',
      invoiceId: 'inv1',
      description: 'compra',
      amountCents: -20000,
      purchaseDate: DateOnly(2026, 8, 1),
      installmentNumber: 1,
      installmentTotal: 1,
      purchaseGroupId: 'g1',
      createdAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllCards()).thenAnswer((_) async => Right([card]));
    when(() => creditCards.getAllInvoices()).thenAnswer((_) async => Right([invoice]));
    when(() => creditCards.getAllItems()).thenAnswer((_) async => Right([item]));

    final result = await useCase(day: day);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) {
      expect(items.length, 1);
      expect(items.single.amountCents, -20000);
      expect(items.single.description, 'Fatura Cartão');
    });
  });

  test('não duplica débito de fatura já paga por uma Transaction concreta', () async {
    final card = CreditCard(
      id: 'c1',
      name: 'Cartão',
      paymentAccountId: 'a1',
      closingDay: 10,
      dueDay: 14,
      owner: AccountOwner.eu,
      createdAt: DateTime(2026),
    );
    final invoice = Invoice(
      id: 'inv1',
      creditCardId: 'c1',
      referenceMonth: '2026-8',
      closingDate: DateOnly(2026, 8, 10),
      dueDate: day,
      status: InvoiceStatus.paga,
      createdAt: DateTime(2026),
    );
    final item = InvoiceItem(
      id: 'i1',
      invoiceId: 'inv1',
      description: 'compra',
      amountCents: -20000,
      purchaseDate: DateOnly(2026, 8, 1),
      installmentNumber: 1,
      installmentTotal: 1,
      purchaseGroupId: 'g1',
      createdAt: DateTime(2026),
    );
    final payment = Transaction(
      id: 'pay1',
      accountId: 'a1',
      description: 'pagamento fatura',
      amountCents: 20000,
      date: day,
      status: TransactionStatus.confirmado,
      invoicePaymentForId: 'inv1',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([payment]));
    when(() => creditCards.getAllCards()).thenAnswer((_) async => Right([card]));
    when(() => creditCards.getAllInvoices()).thenAnswer((_) async => Right([invoice]));
    when(() => creditCards.getAllItems()).thenAnswer((_) async => Right([item]));

    final result = await useCase(day: day);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) {
      expect(items.length, 1);
      expect(items.single.transactionId, 'pay1');
    });
  });
}
