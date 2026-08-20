import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
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
    TransactionCategory category = TransactionCategory.outros,
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
        category: category,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  InvoiceItem buildInvoiceItem({
    required int amountCents,
    required DateOnly purchaseDate,
    TransactionCategory category = TransactionCategory.outros,
  }) =>
      InvoiceItem(
        id: 'i-${purchaseDate.toString()}-$amountCents',
        invoiceId: 'inv1',
        description: 'compra',
        amountCents: amountCents,
        purchaseDate: purchaseDate,
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: 'g1',
        category: category,
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

  test('categoryCents agrupa saídas de conta e gasto de cartão, soma bate com costOfLivingCents',
      () {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -200000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: DateOnly(2026, 8, 5),
      category: TransactionCategory.moradia,
      createdAt: DateTime(2026),
    );

    final result = summarizeMonth(
      transactions: [
        buildTransaction(
          amountCents: -5000,
          date: DateOnly(2026, 8, 10),
          category: TransactionCategory.alimentacao,
        ),
        buildTransaction(
          amountCents: -3000,
          date: DateOnly(2026, 8, 11),
          category: TransactionCategory.alimentacao,
        ),
        // pagamento de fatura não deve entrar em categoryCents (mesmo
        // filtro de expensesCents).
        buildTransaction(
          amountCents: -1500,
          date: DateOnly(2026, 8, 20),
          status: TransactionStatus.confirmado,
          invoicePaymentForId: 'inv1',
          category: TransactionCategory.lazer,
        ),
      ],
      recurrenceRules: [rule],
      invoiceItems: [
        buildInvoiceItem(
          amountCents: -1500,
          purchaseDate: DateOnly(2026, 8, 8),
          category: TransactionCategory.lazer,
        ),
      ],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    expect(result.categoryCents[TransactionCategory.alimentacao], 8000);
    expect(result.categoryCents[TransactionCategory.moradia], 200000);
    expect(result.categoryCents[TransactionCategory.lazer], 1500);
    expect(result.categoryCents.containsKey(TransactionCategory.transporte), isFalse);
    expect(
      result.categoryCents.values.fold<int>(0, (sum, v) => sum + v),
      result.costOfLivingCents,
    );
  });

  test('budget503020 separa necessidade/desejo por categoria e reusa a reserva do resumo', () {
    final summary = summarizeMonth(
      transactions: [
        buildTransaction(
          amountCents: 1000000,
          date: DateOnly(2026, 8, 1),
          status: TransactionStatus.confirmado,
        ),
        buildTransaction(
          amountCents: -400000,
          date: DateOnly(2026, 8, 5),
          category: TransactionCategory.moradia,
        ),
        buildTransaction(
          amountCents: -100000,
          date: DateOnly(2026, 8, 6),
          category: TransactionCategory.lazer,
        ),
      ],
      recurrenceRules: const [],
      invoiceItems: const [],
      year: 2026,
      month: 8,
      savingsTargetPercent: 20,
      today: DateOnly(2026, 9, 1),
    );

    final budget = budget503020(summary);

    expect(budget.necessidadesCents, 400000);
    expect(budget.desejosCents, 100000);
    expect(budget.reservaCents, summary.savedCents);
    expect(budget.reservaPercent, summary.savingsPercent);
    expect(budget.necessidadesPercent, 40.0);
    expect(budget.desejosPercent, 10.0);
  });
}
