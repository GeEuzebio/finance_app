import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/date_only.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/account.dart';
import '../domain/repositories/account_repository.dart';

part 'accounts_providers.g.dart';

@riverpod
AccountRepository accountRepository(Ref ref) => getIt<AccountRepository>();

/// Conta única implícita (M7, #027) — "Contas" deixou de ser uma feature
/// visível, mas a engine de projeção ainda precisa de uma âncora de
/// saldo inicial, então provisiona uma na primeira execução em vez de
/// pedir pro usuário criar. Chamada tanto no boot do app (`main.dart`,
/// garante que a conta existe antes de qualquer tela renderizar —
/// `GetDailyProjection` lê `AccountRepository` direto, sem passar por
/// `AccountsController`) quanto aqui, como reforço.
Future<void> ensureDefaultAccount(AccountRepository repository) async {
  final result = await repository.getAll();
  final accounts = result.match((failure) => throw failure, (accounts) => accounts);
  if (accounts.isNotEmpty) return;

  final defaultAccount = Account(
    id: const Uuid().v4(),
    name: 'Saldo',
    type: AccountType.checking,
    owner: AccountOwner.conjunta,
    initialBalanceCents: 0,
    initialBalanceDate: DateOnly.fromDateTime(DateTime.now()),
    archived: false,
    createdAt: DateTime.now(),
  );
  final upsertResult = await repository.upsert(defaultAccount);
  upsertResult.match((failure) => throw failure, (_) => null);
}

@riverpod
class AccountsController extends _$AccountsController {
  @override
  Future<List<Account>> build() async {
    final repository = ref.read(accountRepositoryProvider);
    await ensureDefaultAccount(repository);
    final result = await repository.getAll();
    return result.match((failure) => throw failure, (accounts) => accounts);
  }

  Future<void> updateInitialBalance(int cents) async {
    final accounts = state.valueOrNull ?? const <Account>[];
    if (accounts.isEmpty) return;
    final current = accounts.first;
    final updated = current.copyWith(
      initialBalanceCents: cents,
      initialBalanceDate: DateOnly.fromDateTime(DateTime.now()),
    );
    final result = await ref.read(accountRepositoryProvider).upsert(updated);
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    await future;
  }
}
