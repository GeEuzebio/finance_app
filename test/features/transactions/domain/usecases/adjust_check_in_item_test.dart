import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/check_in_item.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/adjust_check_in_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late AdjustCheckInItem useCase;

  setUpAll(() => registerFallbackValue(
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
      ));

  setUp(() {
    repository = _MockTransactionRepository();
    useCase = AdjustCheckInItem(repository);
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));
  });

  test('materializa com o novo valor e status ajustado', () async {
    final item = CheckInItem(
      accountId: 'a1',
      accountName: 'Conta',
      description: 'aluguel',
      amountCents: -300000,
      date: DateOnly(2026, 8, 14),
      recurrenceRuleId: 'r1',
    );

    final result = await useCase(item, newAmountCents: -320000);

    expect(result.isRight(), isTrue);
    final captured = verify(() => repository.upsert(captureAny())).captured.single as Transaction;
    expect(captured.amountCents, -320000);
    expect(captured.status, TransactionStatus.ajustado);
    expect(captured.date, DateOnly(2026, 8, 14));
  });
}
