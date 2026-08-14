import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/transactions/domain/entities/check_in_item.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_app/features/transactions/domain/usecases/postpone_check_in_item.dart';
import 'package:finance_app/features/transactions/domain/usecases/recurrence_override_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockTransactionRepository repository;
  late PostponeCheckInItem useCase;

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
    useCase = PostponeCheckInItem(repository);
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));
  });

  test('marca original como adiado e cria nova ocorrência previsto na nova data', () async {
    final item = CheckInItem(
      accountId: 'a1',
      accountName: 'Conta',
      description: 'aluguel',
      amountCents: -300000,
      date: DateOnly(2026, 8, 14),
      recurrenceRuleId: 'r1',
    );

    final result = await useCase(item, newDate: DateOnly(2026, 8, 20));

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => repository.upsert(captureAny())).captured.cast<Transaction>();
    expect(captured.length, 2);

    final original = captured.firstWhere((t) => t.status == TransactionStatus.adiado);
    expect(original.date, DateOnly(2026, 8, 14));
    expect(original.id, recurrenceOverrideId('r1', DateOnly(2026, 8, 14)));

    final postponed = captured.firstWhere((t) => t.status == TransactionStatus.previsto);
    expect(postponed.date, DateOnly(2026, 8, 20));
    expect(postponed.originalTransactionId, original.id);
    expect(postponed.amountCents, -300000);
  });
}
