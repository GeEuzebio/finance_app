import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart' show AccountOwner;
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/credit_cards/domain/usecases/pay_invoice.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockCreditCardRepository cardRepository;
  late _MockTransactionRepository transactionRepository;
  late PayInvoice useCase;

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
    id: 'inv1',
    creditCardId: 'c1',
    referenceMonth: '2026-03',
    closingDate: DateOnly(2026, 3, 10),
    dueDate: DateOnly(2026, 3, 20),
    status: InvoiceStatus.aberta,
    createdAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(invoice);
    registerFallbackValue(
      Transaction(
        id: 'fallback',
        accountId: 'a',
        description: 'x',
        amountCents: 0,
        date: DateOnly(2026, 1, 1),
        status: TransactionStatus.previsto,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    cardRepository = _MockCreditCardRepository();
    transactionRepository = _MockTransactionRepository();
    useCase = PayInvoice(cardRepository, transactionRepository);

    when(() => cardRepository.getInvoiceById('inv1')).thenAnswer((_) async => Right(invoice));
    when(() => cardRepository.upsertInvoice(any())).thenAnswer((_) async => const Right(unit));
  });

  test('fatura com total zero não gera Transaction, só muda status pra paga', () async {
    when(() => cardRepository.totalCentsForInvoice('inv1'))
        .thenAnswer((_) async => const Right(0));

    final result = await useCase(invoiceId: 'inv1', paymentDate: DateOnly(2026, 3, 20));

    expect(result.isRight(), isTrue);
    verifyNever(() => transactionRepository.upsert(any()));
    final updated =
        verify(() => cardRepository.upsertInvoice(captureAny())).captured.single as Invoice;
    expect(updated.status, InvoiceStatus.paga);
  });

  test('fatura com total != 0 gera Transaction de pagamento e marca paga', () async {
    when(() => cardRepository.totalCentsForInvoice('inv1'))
        .thenAnswer((_) async => const Right(-15000));
    when(() => cardRepository.getCardById('c1')).thenAnswer((_) async => Right(card));
    when(() => transactionRepository.upsert(any())).thenAnswer((_) async => const Right(unit));

    final result = await useCase(invoiceId: 'inv1', paymentDate: DateOnly(2026, 3, 20));

    expect(result.isRight(), isTrue);
    final payment = verify(() => transactionRepository.upsert(captureAny())).captured.single
        as Transaction;
    expect(payment.amountCents, -15000);
    expect(payment.accountId, 'a1');
    expect(payment.invoicePaymentForId, 'inv1');
    expect(payment.status, TransactionStatus.confirmado);
    final updated =
        verify(() => cardRepository.upsertInvoice(captureAny())).captured.single as Invoice;
    expect(updated.status, InvoiceStatus.paga);
  });
}
