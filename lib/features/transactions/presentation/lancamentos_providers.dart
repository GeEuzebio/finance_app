import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/errors/failure.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/recurrence_rule.dart';
import '../domain/entities/transaction.dart';
import '../domain/repositories/recurrence_repository.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/create_recurrence_rule.dart';
import '../domain/usecases/create_transaction.dart';

part 'lancamentos_providers.g.dart';

typedef LancamentosData = ({
  List<Transaction> avulsos,
  List<RecurrenceRule> fixas,
  List<RecurrenceRule> variaveis,
});

@riverpod
TransactionRepository transactionRepository(Ref ref) => getIt<TransactionRepository>();
@riverpod
RecurrenceRepository recurrenceRepository(Ref ref) => getIt<RecurrenceRepository>();
@riverpod
CreateTransaction createTransactionUseCase(Ref ref) => getIt<CreateTransaction>();
@riverpod
CreateRecurrenceRule createRecurrenceRuleUseCase(Ref ref) => getIt<CreateRecurrenceRule>();

@riverpod
class LancamentosController extends _$LancamentosController {
  @override
  Future<LancamentosData> build() async {
    final transactions = await _unwrap(ref.read(transactionRepositoryProvider).getAll());
    final rules = await _unwrap(ref.read(recurrenceRepositoryProvider).getAll());

    final avulsos = transactions
        .where((t) =>
            t.recurrenceRuleId == null &&
            t.originalTransactionId == null &&
            t.invoicePaymentForId == null)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return (
      avulsos: avulsos,
      fixas: rules.where((r) => !r.isVariable).toList(),
      variaveis: rules.where((r) => r.isVariable).toList(),
    );
  }

  Future<void> createTransaction(Transaction transaction) =>
      _run(() => ref.read(createTransactionUseCaseProvider).call(transaction));

  Future<void> createRecurrenceRule(RecurrenceRule rule) =>
      _run(() => ref.read(createRecurrenceRuleUseCaseProvider).call(rule));

  Future<void> _run(Future<Either<Failure, Unit>> Function() action) async {
    final result = await action();
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    await future;
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
