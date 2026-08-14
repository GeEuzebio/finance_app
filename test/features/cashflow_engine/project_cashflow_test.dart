import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:finance_app/features/cashflow_engine/domain/entities/account_snapshot.dart';
import 'package:finance_app/features/cashflow_engine/domain/entities/daily_balance.dart';
import 'package:finance_app/features/cashflow_engine/domain/installment_distribution.dart';
import 'package:finance_app/features/cashflow_engine/domain/invoice_cycle.dart';
import 'package:finance_app/features/cashflow_engine/domain/project_cashflow.dart';
import 'package:finance_app/features/credit_cards/domain/entities/credit_card.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

// Helpers para reduzir boilerplate nos 15 casos de docs/CASHFLOW_ENGINE.md §5.

DateOnly d(int day, int month, int year) => DateOnly(year, month, day);

AccountSnapshot account(
  String id,
  int initialBalanceCents,
  DateOnly initialBalanceDate, {
  bool archived = false,
}) =>
    AccountSnapshot(
      id: id,
      initialBalanceCents: initialBalanceCents,
      initialBalanceDate: initialBalanceDate,
      archived: archived,
    );

Transaction tx({
  required String id,
  required String accountId,
  required int amountCents,
  required DateOnly date,
  TransactionStatus status = TransactionStatus.previsto,
  String? recurrenceRuleId,
  String? originalTransactionId,
  String? transferGroupId,
  String? invoicePaymentForId,
}) =>
    Transaction(
      id: id,
      accountId: accountId,
      description: 'teste',
      amountCents: amountCents,
      date: date,
      status: status,
      recurrenceRuleId: recurrenceRuleId,
      originalTransactionId: originalTransactionId,
      transferGroupId: transferGroupId,
      invoicePaymentForId: invoicePaymentForId,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

RecurrenceRule rule({
  required String id,
  required String accountId,
  required int amountCents,
  required RecurrenceFrequency frequency,
  required DateOnly startDate,
  int interval = 1,
  DateOnly? endDate,
  int? occurrenceCount,
}) =>
    RecurrenceRule(
      id: id,
      accountId: accountId,
      description: 'teste',
      amountCents: amountCents,
      frequency: frequency,
      interval: interval,
      startDate: startDate,
      endDate: endDate,
      occurrenceCount: occurrenceCount,
      createdAt: DateTime(2026),
    );

CreditCard card(String id, String paymentAccountId, int closingDay, int dueDay) =>
    CreditCard(
      id: id,
      name: 'cartão teste',
      paymentAccountId: paymentAccountId,
      closingDay: closingDay,
      dueDay: dueDay,
      owner: AccountOwner.eu,
      createdAt: DateTime(2026),
    );

Invoice invoice(String id, String creditCardId, DateOnly closingDate, DateOnly dueDate) =>
    Invoice(
      id: id,
      creditCardId: creditCardId,
      referenceMonth: '${closingDate.year}-${closingDate.month.toString().padLeft(2, '0')}',
      closingDate: closingDate,
      dueDate: dueDate,
      status: InvoiceStatus.aberta,
      createdAt: DateTime(2026),
    );

InvoiceItem item({
  required String id,
  required String invoiceId,
  required int amountCents,
  required DateOnly purchaseDate,
  int installmentNumber = 1,
  int installmentTotal = 1,
  String purchaseGroupId = 'g1',
}) =>
    InvoiceItem(
      id: id,
      invoiceId: invoiceId,
      description: 'item teste',
      amountCents: amountCents,
      purchaseDate: purchaseDate,
      installmentNumber: installmentNumber,
      installmentTotal: installmentTotal,
      purchaseGroupId: purchaseGroupId,
      createdAt: DateTime(2026),
    );

DailyBalance find(List<DailyBalance> result, DateOnly date, {String? accountId}) =>
    result.firstWhere((b) => b.date == date && b.accountId == accountId);

void main() {
  test('1. crédito e débito no mesmo dia', () {
    final result = projectCashflow(
      accounts: [account('A', 100000, d(1, 8, 2026))],
      transactions: [
        tx(id: 't1', accountId: 'A', amountCents: 50000, date: d(1, 8, 2026)),
        tx(id: 't2', accountId: 'A', amountCents: -20000, date: d(1, 8, 2026)),
      ],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 8, 2026),
      horizonEnd: d(1, 8, 2026),
    );

    expect(find(result, d(1, 8, 2026), accountId: 'A').closingBalanceCents, 130000);
  });

  test('2. recorrência mensal simples', () {
    final result = projectCashflow(
      accounts: [account('A', 1000000, d(1, 1, 2026))],
      transactions: [],
      recurrenceRules: [
        rule(
          id: 'r1',
          accountId: 'A',
          amountCents: -300000,
          frequency: RecurrenceFrequency.monthly,
          startDate: d(5, 1, 2026),
        ),
      ],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 1, 2026),
      horizonEnd: d(31, 3, 2026),
    );

    expect(find(result, d(5, 1, 2026), accountId: 'A').closingBalanceCents, 700000);
    expect(find(result, d(5, 2, 2026), accountId: 'A').closingBalanceCents, 400000);
    expect(find(result, d(5, 3, 2026), accountId: 'A').closingBalanceCents, 100000);
  });

  test('3. dia inválido — fevereiro não bissexto', () {
    final result = projectCashflow(
      accounts: [account('A', 500000, d(1, 1, 2026))],
      transactions: [],
      recurrenceRules: [
        rule(
          id: 'r1',
          accountId: 'A',
          amountCents: -50000,
          frequency: RecurrenceFrequency.monthly,
          startDate: d(31, 1, 2026),
        ),
      ],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 1, 2026),
      horizonEnd: d(31, 3, 2026),
    );

    expect(find(result, d(31, 1, 2026), accountId: 'A').closingBalanceCents, 450000);
    expect(find(result, d(28, 2, 2026), accountId: 'A').closingBalanceCents, 400000);
    expect(find(result, d(31, 3, 2026), accountId: 'A').closingBalanceCents, 350000);
  });

  test('4. dia inválido — fevereiro bissexto', () {
    final result = projectCashflow(
      accounts: [account('A', 500000, d(1, 1, 2028))],
      transactions: [],
      recurrenceRules: [
        rule(
          id: 'r1',
          accountId: 'A',
          amountCents: -50000,
          frequency: RecurrenceFrequency.monthly,
          startDate: d(31, 1, 2028),
        ),
      ],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 1, 2028),
      horizonEnd: d(31, 3, 2028),
    );

    // nada acontece em 28/02 — a ocorrência clampada é em 29/02, não em 28/02
    expect(find(result, d(28, 2, 2028), accountId: 'A').closingBalanceCents, 450000);
    expect(find(result, d(29, 2, 2028), accountId: 'A').closingBalanceCents, 400000);
  });

  test('5. virada de ano', () {
    final result = projectCashflow(
      accounts: [account('A', 200000, d(1, 12, 2026))],
      transactions: [],
      recurrenceRules: [
        rule(
          id: 'r1',
          accountId: 'A',
          amountCents: -80000,
          frequency: RecurrenceFrequency.monthly,
          startDate: d(15, 12, 2026),
        ),
      ],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 12, 2026),
      horizonEnd: d(31, 1, 2027),
    );

    expect(find(result, d(15, 12, 2026), accountId: 'A').closingBalanceCents, 120000);
    expect(find(result, d(15, 1, 2027), accountId: 'A').closingBalanceCents, 40000);
  });

  test('6. compra de cartão antes do fechamento cai na fatura atual', () {
    expect(resolveInvoiceCycle(d(8, 3, 2026), 10), (year: 2026, month: 3));

    final c = card('c1', 'A', 10, 20);
    final march = invoice('fatura-2026-03', 'c1', d(10, 3, 2026), d(20, 3, 2026));
    final purchase = item(
      id: 'i1',
      invoiceId: 'fatura-2026-03',
      amountCents: -15000,
      purchaseDate: d(8, 3, 2026),
    );

    final result = projectCashflow(
      accounts: [account('A', 500000, d(1, 3, 2026))],
      transactions: [],
      recurrenceRules: [],
      creditCards: [c],
      invoices: [march],
      invoiceItems: [purchase],
      reserves: [],
      horizonStart: d(1, 3, 2026),
      horizonEnd: d(31, 3, 2026),
    );

    expect(find(result, d(20, 3, 2026), accountId: 'A').closingBalanceCents, 485000);
  });

  test('7. compra no mesmo dia do fechamento cai na fatura atual, não na seguinte', () {
    expect(resolveInvoiceCycle(d(10, 3, 2026), 10), (year: 2026, month: 3));
    expect(resolveInvoiceCycle(d(10, 3, 2026), 10), isNot((year: 2026, month: 4)));

    final c = card('c1', 'A', 10, 20);
    final march = invoice('fatura-2026-03', 'c1', d(10, 3, 2026), d(20, 3, 2026));
    final april = invoice('fatura-2026-04', 'c1', d(10, 4, 2026), d(20, 4, 2026));
    final purchase = item(
      id: 'i1',
      invoiceId: 'fatura-2026-03',
      amountCents: -20000,
      purchaseDate: d(10, 3, 2026),
    );

    final result = projectCashflow(
      accounts: [account('A', 500000, d(1, 3, 2026))],
      transactions: [],
      recurrenceRules: [],
      creditCards: [c],
      invoices: [march, april],
      invoiceItems: [purchase],
      reserves: [],
      horizonStart: d(1, 3, 2026),
      horizonEnd: d(30, 4, 2026),
    );

    expect(find(result, d(20, 3, 2026), accountId: 'A').closingBalanceCents, 480000);
    // fatura de abril não tem itens (totalCents == 0) — nenhum débito novo
    expect(find(result, d(20, 4, 2026), accountId: 'A').closingBalanceCents, 480000);
  });

  test('8. parcelamento com resíduo de centavo', () {
    final installments = distributeInstallments(-10000, 3);
    expect(installments, [-3334, -3333, -3333]);
    expect(installments.reduce((a, b) => a + b), -10000);

    final c = card('c1', 'A', 10, 20);
    final invoices = [
      invoice('fatura-2026-05', 'c1', d(10, 5, 2026), d(20, 5, 2026)),
      invoice('fatura-2026-06', 'c1', d(10, 6, 2026), d(20, 6, 2026)),
      invoice('fatura-2026-07', 'c1', d(10, 7, 2026), d(20, 7, 2026)),
    ];
    final items = [
      item(
        id: 'i1',
        invoiceId: 'fatura-2026-05',
        amountCents: installments[0],
        purchaseDate: d(1, 5, 2026),
        installmentNumber: 1,
        installmentTotal: 3,
      ),
      item(
        id: 'i2',
        invoiceId: 'fatura-2026-06',
        amountCents: installments[1],
        purchaseDate: d(1, 6, 2026),
        installmentNumber: 2,
        installmentTotal: 3,
      ),
      item(
        id: 'i3',
        invoiceId: 'fatura-2026-07',
        amountCents: installments[2],
        purchaseDate: d(1, 7, 2026),
        installmentNumber: 3,
        installmentTotal: 3,
      ),
    ];

    final result = projectCashflow(
      accounts: [account('A', 100000, d(1, 5, 2026))],
      transactions: [],
      recurrenceRules: [],
      creditCards: [c],
      invoices: invoices,
      invoiceItems: items,
      reserves: [],
      horizonStart: d(1, 5, 2026),
      horizonEnd: d(31, 7, 2026),
    );

    expect(find(result, d(20, 5, 2026), accountId: 'A').closingBalanceCents, 96666);
    expect(find(result, d(20, 6, 2026), accountId: 'A').closingBalanceCents, 93333);
    expect(find(result, d(20, 7, 2026), accountId: 'A').closingBalanceCents, 90000);
  });

  test('9. saldo negativo', () {
    final result = projectCashflow(
      accounts: [account('A', 10000, d(1, 4, 2026))],
      transactions: [
        tx(id: 't1', accountId: 'A', amountCents: -50000, date: d(5, 4, 2026)),
      ],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 4, 2026),
      horizonEnd: d(5, 4, 2026),
    );

    expect(find(result, d(5, 4, 2026), accountId: 'A').closingBalanceCents, -40000);
  });

  test('10. transferência entre contas próprias', () {
    final result = projectCashflow(
      accounts: [
        account('A', 100000, d(1, 6, 2026)),
        account('B', 50000, d(1, 6, 2026)),
      ],
      transactions: [
        tx(
          id: 't1',
          accountId: 'A',
          amountCents: -30000,
          date: d(10, 6, 2026),
          transferGroupId: 'tr1',
        ),
        tx(
          id: 't2',
          accountId: 'B',
          amountCents: 30000,
          date: d(10, 6, 2026),
          transferGroupId: 'tr1',
        ),
      ],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 6, 2026),
      horizonEnd: d(10, 6, 2026),
    );

    expect(find(result, d(10, 6, 2026), accountId: 'A').closingBalanceCents, 70000);
    expect(find(result, d(10, 6, 2026), accountId: 'B').closingBalanceCents, 80000);
    expect(find(result, d(1, 6, 2026)).closingBalanceCents, 150000);
    expect(find(result, d(10, 6, 2026)).closingBalanceCents, 150000);
  });

  test('11. reserva reduz saldo livre, não o total', () {
    final result = projectCashflow(
      accounts: [account('A', 200000, d(1, 7, 2026))],
      transactions: [],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [
        Reserve(
          id: 'r1',
          name: 'Emergência',
          currentAmountCents: 50000,
          createdAt: DateTime(2026),
        ),
      ],
      horizonStart: d(1, 7, 2026),
      horizonEnd: d(1, 7, 2026),
    );

    final consolidated = find(result, d(1, 7, 2026));
    expect(consolidated.closingBalanceCents, 200000);
    expect(consolidated.freeBalanceCents, 150000);
  });

  test('12. previsão vencida não conciliada é determinística', () {
    final accounts = [account('A', 100000, d(1, 8, 2026))];
    final transactions = [
      tx(id: 't1', accountId: 'A', amountCents: -40000, date: d(5, 8, 2026)),
    ];

    final resultDesde01 = projectCashflow(
      accounts: accounts,
      transactions: transactions,
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 8, 2026),
      horizonEnd: d(9, 8, 2026),
    );
    final resultDesde09 = projectCashflow(
      accounts: accounts,
      transactions: transactions,
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(9, 8, 2026),
      horizonEnd: d(9, 8, 2026),
    );

    expect(find(resultDesde01, d(5, 8, 2026), accountId: 'A').closingBalanceCents, 60000);
    // rodar a função a partir de uma data posterior ao vencimento não muda
    // o resultado do dia 9 — o débito de 05/08 já foi absorvido, nunca
    // "arrastado" nem duplicado.
    expect(
      find(resultDesde09, d(9, 8, 2026), accountId: 'A').closingBalanceCents,
      find(resultDesde01, d(9, 8, 2026), accountId: 'A').closingBalanceCents,
    );
  });

  test('13. cancelamento exclui da soma', () {
    final result = projectCashflow(
      accounts: [account('A', 100000, d(1, 8, 2026))],
      transactions: [
        tx(
          id: 't1',
          accountId: 'A',
          amountCents: -25000,
          date: d(12, 8, 2026),
          status: TransactionStatus.cancelado,
        ),
      ],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 8, 2026),
      horizonEnd: d(12, 8, 2026),
    );

    final day = find(result, d(12, 8, 2026), accountId: 'A');
    expect(day.closingBalanceCents, day.openingBalanceCents);
    expect(day.closingBalanceCents, 100000);
  });

  test('14. adiamento move o efeito para a nova data', () {
    final result = projectCashflow(
      accounts: [account('A', 100000, d(1, 8, 2026))],
      transactions: [
        tx(
          id: 'orig',
          accountId: 'A',
          amountCents: -10000,
          date: d(3, 8, 2026),
          status: TransactionStatus.adiado,
        ),
        tx(
          id: 'novo',
          accountId: 'A',
          amountCents: -10000,
          date: d(10, 8, 2026),
          originalTransactionId: 'orig',
        ),
      ],
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 8, 2026),
      horizonEnd: d(10, 8, 2026),
    );

    expect(find(result, d(3, 8, 2026), accountId: 'A').closingBalanceCents, 100000);
    expect(find(result, d(10, 8, 2026), accountId: 'A').closingBalanceCents, 90000);
  });

  test('15. estorno zera a fatura e não gera pagamento', () {
    final c = card('c1', 'A', 10, 20);
    final september = invoice('fatura-2026-09', 'c1', d(10, 9, 2026), d(20, 9, 2026));
    final items = [
      item(id: 'i1', invoiceId: 'fatura-2026-09', amountCents: -8000, purchaseDate: d(3, 9, 2026)),
      item(id: 'i2', invoiceId: 'fatura-2026-09', amountCents: 8000, purchaseDate: d(5, 9, 2026)),
    ];

    final result = projectCashflow(
      accounts: [account('A', 100000, d(1, 9, 2026))],
      transactions: [],
      recurrenceRules: [],
      creditCards: [c],
      invoices: [september],
      invoiceItems: items,
      reserves: [],
      horizonStart: d(1, 9, 2026),
      horizonEnd: d(20, 9, 2026),
    );

    final dueDay = find(result, d(20, 9, 2026), accountId: 'A');
    expect(dueDay.closingBalanceCents, 100000);
    expect(dueDay.projectedDebitsCents, 0);
  });

  test('projeta 12 meses com 500 lançamentos em menos de 50ms', () {
    final transactions = List.generate(500, (i) {
      final day = 1 + (i % 27);
      final month = 1 + ((i ~/ 27) % 12);
      return tx(
        id: 't$i',
        accountId: 'A',
        amountCents: i.isEven ? 1000 : -1000,
        date: d(day, month, 2026),
      );
    });

    final stopwatch = Stopwatch()..start();
    final result = projectCashflow(
      accounts: [account('A', 1000000, d(1, 1, 2026))],
      transactions: transactions,
      recurrenceRules: [],
      creditCards: [],
      invoices: [],
      invoiceItems: [],
      reserves: [],
      horizonStart: d(1, 1, 2026),
      horizonEnd: d(31, 12, 2026),
    );
    stopwatch.stop();

    expect(result, isNotEmpty);
    expect(stopwatch.elapsedMilliseconds, lessThan(50));
  });
}
