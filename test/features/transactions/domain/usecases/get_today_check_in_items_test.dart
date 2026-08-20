import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:finance_app/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_app/features/transactions/domain/entities/recurrence_rule.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/get_today_check_in_items.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockTransactionRepository extends Mock implements TransactionRepository {}

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

void main() {
  late _MockAccountRepository accounts;
  late _MockTransactionRepository transactions;
  late _MockRecurrenceRepository recurrences;
  late GetTodayCheckInItems useCase;

  final today = DateOnly(2026, 8, 14);
  final account = Account(
    id: 'a1',
    name: 'Conta',
    type: AccountType.checking,
    owner: AccountOwner.eu,
    initialBalanceCents: 0,
    initialBalanceDate: today,
    archived: false,
    createdAt: DateTime(2026),
  );

  setUp(() {
    accounts = _MockAccountRepository();
    transactions = _MockTransactionRepository();
    recurrences = _MockRecurrenceRepository();
    useCase = GetTodayCheckInItems(accounts, transactions, recurrences);
    when(() => accounts.getAll()).thenAnswer((_) async => Right([account]));
  });

  test('inclui Transaction pontual previsto de hoje', () async {
    final t = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'compra',
      amountCents: -1000,
      date: today,
      status: TransactionStatus.previsto,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([t]));
    when(() => recurrences.getAll()).thenAnswer((_) async => const Right([]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) {
      expect(items.length, 1);
      expect(items.single.transactionId, 't1');
      expect(items.single.isVirtual, isFalse);
      expect(items.single.accountName, 'Conta');
    });
  });

  test('não inclui Transaction de outro dia nem de status já resolvido', () async {
    final wrongDay = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'x',
      amountCents: -1000,
      date: today.addDays(1),
      status: TransactionStatus.previsto,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    final wrongStatus = Transaction(
      id: 't2',
      accountId: 'a1',
      description: 'y',
      amountCents: -1000,
      date: today,
      status: TransactionStatus.confirmado,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([wrongDay, wrongStatus]));
    when(() => recurrences.getAll()).thenAnswer((_) async => const Right([]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) => expect(items, isEmpty));
  });

  test('inclui ocorrência virtual de RecurrenceRule que cai hoje', () async {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: today,
      category: TransactionCategory.moradia,
      createdAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => const Right([]));
    when(() => recurrences.getAll()).thenAnswer((_) async => Right([rule]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) {
      expect(items.length, 1);
      expect(items.single.isVirtual, isTrue);
      expect(items.single.recurrenceRuleId, 'r1');
      expect(items.single.transactionId, isNull);
      expect(items.single.category, TransactionCategory.moradia);
    });
  });

  test('regra que não ocorre hoje não gera item virtual', () async {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: today.addDays(1),
      createdAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => const Right([]));
    when(() => recurrences.getAll()).thenAnswer((_) async => Right([rule]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) => expect(items, isEmpty));
  });

  test('regra com override hoje (qualquer status) não gera virtual duplicada', () async {
    final rule = RecurrenceRule(
      id: 'r1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      frequency: RecurrenceFrequency.monthly,
      interval: 1,
      startDate: today,
      createdAt: DateTime(2026),
    );
    final override = Transaction(
      id: 't1',
      accountId: 'a1',
      description: 'aluguel',
      amountCents: -300000,
      date: today,
      status: TransactionStatus.cancelado,
      recurrenceRuleId: 'r1',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    when(() => transactions.getAll()).thenAnswer((_) async => Right([override]));
    when(() => recurrences.getAll()).thenAnswer((_) async => Right([rule]));

    final result = await useCase(today: today);

    result.match((l) => fail('esperava Right, recebeu $l'), (items) => expect(items, isEmpty));
  });
}
