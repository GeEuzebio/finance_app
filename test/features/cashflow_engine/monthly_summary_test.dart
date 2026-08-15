import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/cashflow_engine/domain/monthly_summary.dart';
import 'package:finance_app/features/credit_cards/domain/entities/invoice_item.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Transaction buildTransaction({
    required int amountCents,
    required DateOnly date,
    TransactionStatus status = TransactionStatus.previsto,
    String? invoicePaymentForId,
    String? recurrenceRuleId,
  }) =>
      Transaction(
        id: 't-${date.toString()}-$amountCents',
        accountId: 'a1',
        description: 'x',
        amountCents: amountCents,
        date: date,
        status: status,
        invoicePaymentForId: invoicePaymentForId,
        recurrenceRuleId: recurrenceRuleId,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  InvoiceItem buildInvoiceItem({required int amountCents, required DateOnly purchaseDate}) =>
      InvoiceItem(
        id: 'i-${purchaseDate.toString()}-$amountCents',
        invoiceId: 'inv1',
        description: 'compra',
        amountCents: amountCents,
        purchaseDate: purchaseDate,
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        createdAt: DateTime(2026),
      );

  test('exclui pagamento de fatura das saídas — a compra conta uma vez só via cardSpendCents', () {
    final result = summarizeMonth(
      transactions: [
        buildTransaction(
          amountCents: 500000,
          date: DateOnly(2026, 8, 5),
          status: TransactionStatus.confirmado,
        ),
        buildTransaction(amountCents: -100000, date: DateOnly(2026, 8, 10)),
        buildTransaction(
          amountCents: -80000,
          date: DateOnly(2026, 8, 15),
          status: TransactionStatus.confirmado,
          invoicePaymentForId: 'inv1',
        ),
      ],
      recurrenceRules: const [],
      invoiceItems: [
        buildInvoiceItem(amountCents: -80000, purchaseDate: DateOnly(2026, 8, 8)),
      ],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    expect(result.incomeCents, 500000);
    expect(result.expensesCents, 100000);
    expect(result.cardSpendCents, 80000);
    expect(result.costOfLivingCents, 180000);
  });

  test('exclui transações canceladas e adiadas do mês', () {
    final result = summarizeMonth(
      transactions: [
        buildTransaction(
          amountCents: -999999,
          date: DateOnly(2026, 8, 12),
          status: TransactionStatus.cancelado,
        ),
        buildTransaction(
          amountCents: -999999,
          date: DateOnly(2026, 8, 13),
          status: TransactionStatus.adiado,
        ),
      ],
      recurrenceRules: const [],
      invoiceItems: const [],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    expect(result.expensesCents, 0);
  });

  test('inclui ocorrência virtual de RecurrenceRule dentro do mês', () {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -250000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: DateOnly(2026, 8, 5),
      createdAt: DateTime(2026),
    );

    final result = summarizeMonth(
      transactions: const [],
      recurrenceRules: [rule],
      invoiceItems: const [],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    expect(result.expensesCents, 250000);
  });

  test('calcula % de economia e se bateu a meta', () {
    final result = summarizeMonth(
      transactions: [
        buildTransaction(
          amountCents: 100000,
          date: DateOnly(2026, 8, 5),
          status: TransactionStatus.confirmado,
        ),
        buildTransaction(amountCents: -70000, date: DateOnly(2026, 8, 10)),
      ],
      recurrenceRules: const [],
      invoiceItems: const [],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    expect(result.savedCents, 30000);
    expect(result.savingsPercent, 30.0);
    expect(result.isSavingsOnTarget, isTrue);
  });
}
