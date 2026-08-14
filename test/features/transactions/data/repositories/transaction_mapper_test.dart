import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('transactionFromJson(transactionToJson(x)) faz roundtrip, campos nulos inclusive', () {
    final transaction = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'lançamento',
      amountCents: -1000,
      date: DateOnly(2026, 8, 1),
      status: TransactionStatus.previsto,
      createdAt: DateTime.utc(2026, 8, 1),
      updatedAt: DateTime.utc(2026, 8, 1),
    );

    final json = transactionToJson(transaction);
    expect(json['recurrence_rule_id'], isNull);
    expect(json['status'], 'previsto');

    expect(transactionFromJson(json), transaction);
  });

  test('transactionFromJson(transactionToJson(x)) preserva vínculos de recorrência/adiamento', () {
    final transaction = Transaction(
      id: 't2',
      accountId: 'a1',
      description: 'aluguel adiado',
      amountCents: -300000,
      date: DateOnly(2026, 8, 10),
      status: TransactionStatus.previsto,
      recurrenceRuleId: 'r1',
      originalTransactionId: 'orig',
      transferGroupId: 'tr1',
      invoicePaymentForId: 'i1',
      createdAt: DateTime.utc(2026, 8, 1),
      updatedAt: DateTime.utc(2026, 8, 2),
    );

    expect(transactionFromJson(transactionToJson(transaction)), transaction);
  });
}
