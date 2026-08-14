import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:finance_app/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_app/features/cashflow_engine/domain/usecases/get_daily_projection.dart';
import 'package:finance_app/features/credit_cards/domain/repositories/credit_card_repository.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:finance_app/features/reserves/domain/repositories/reserve_repository.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/recurrence_repository.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockTransactionRepository extends Mock implements TransactionRepository {}

class _MockRecurrenceRepository extends Mock implements RecurrenceRepository {}

class _MockCreditCardRepository extends Mock implements CreditCardRepository {}

class _MockReserveRepository extends Mock implements ReserveRepository {}

void main() {
  late _MockAccountRepository accounts;
  late _MockTransactionRepository transactions;
  late _MockRecurrenceRepository recurrences;
  late _MockCreditCardRepository creditCards;
  late _MockReserveRepository reserves;
  late GetDailyProjection useCase;

  setUp(() {
    accounts = _MockAccountRepository();
    transactions = _MockTransactionRepository();
    recurrences = _MockRecurrenceRepository();
    creditCards = _MockCreditCardRepository();
    reserves = _MockReserveRepository();
    useCase = GetDailyProjection(accounts, transactions, recurrences, creditCards, reserves);
  });

  void stubEmptyRest() {
    when(() => recurrences.getAll()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllCards()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllItems()).thenAnswer((_) async => const Right([]));
    when(() => reserves.getAll()).thenAnswer((_) async => const Right([]));
  }

  test('busca os 5 repositórios e alimenta a engine — caso 1 do CASHFLOW_ENGINE.md', () async {
    final account = Account(
      id: 'A',
      name: 'Conta',
      type: AccountType.checking,
      owner: AccountOwner.eu,
      initialBalanceCents: 100000,
      initialBalanceDate: DateOnly(2026, 8, 1),
      archived: false,
      createdAt: DateTime(2026),
    );
    final credit = Transaction(
      id: 't1',
      accountId: 'A',
      description: 'x',
      amountCents: 50000,
      date: DateOnly(2026, 8, 1),
      status: TransactionStatus.previsto,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    final debit = Transaction(
      id: 't2',
      accountId: 'A',
      description: 'y',
      amountCents: -20000,
      date: DateOnly(2026, 8, 1),
      status: TransactionStatus.previsto,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    when(() => accounts.getAll()).thenAnswer((_) async => Right([account]));
    when(() => transactions.getAll()).thenAnswer((_) async => Right([credit, debit]));
    stubEmptyRest();

    final result = await useCase(
      horizonStart: DateOnly(2026, 8, 1),
      horizonEnd: DateOnly(2026, 8, 1),
    );

    result.match(
      (l) => fail('esperava Right, recebeu $l'),
      (balances) {
        final accountBalance = balances.firstWhere((b) => b.accountId == 'A');
        expect(accountBalance.closingBalanceCents, 130000);
      },
    );
  });

  test('freeBalanceCents consolidado reflete a soma das reservas (#013)', () async {
    final account = Account(
      id: 'A',
      name: 'Conta',
      type: AccountType.checking,
      owner: AccountOwner.eu,
      initialBalanceCents: 200000,
      initialBalanceDate: DateOnly(2026, 7, 1),
      archived: false,
      createdAt: DateTime(2026),
    );
    final reserve = Reserve(
      id: 'r1',
      name: 'Emergência',
      currentAmountCents: 50000,
      createdAt: DateTime(2026),
    );

    when(() => accounts.getAll()).thenAnswer((_) async => Right([account]));
    when(() => transactions.getAll()).thenAnswer((_) async => const Right([]));
    when(() => recurrences.getAll()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllCards()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllInvoices()).thenAnswer((_) async => const Right([]));
    when(() => creditCards.getAllItems()).thenAnswer((_) async => const Right([]));
    when(() => reserves.getAll()).thenAnswer((_) async => Right([reserve]));

    final result = await useCase(
      horizonStart: DateOnly(2026, 7, 1),
      horizonEnd: DateOnly(2026, 7, 1),
    );

    result.match(
      (l) => fail('esperava Right, recebeu $l'),
      (balances) {
        final consolidated = balances.firstWhere((b) => b.accountId == null);
        expect(consolidated.closingBalanceCents, 200000);
        expect(consolidated.freeBalanceCents, 150000);
      },
    );
  });

  test('propaga Left se algum repositório falhar', () async {
    when(() => accounts.getAll()).thenAnswer((_) async => const Left(DatabaseFailure('erro')));

    final result = await useCase(
      horizonStart: DateOnly(2026, 8, 1),
      horizonEnd: DateOnly(2026, 8, 1),
    );

    expect(result.isLeft(), isTrue);
  });
}
