import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/account.dart';
import '../domain/repositories/account_repository.dart';

part 'accounts_providers.g.dart';

@riverpod
AccountRepository accountRepository(Ref ref) => getIt<AccountRepository>();

@riverpod
class AccountsController extends _$AccountsController {
  @override
  Future<List<Account>> build() async {
    final result = await ref.read(accountRepositoryProvider).getAll();
    return result.match((failure) => throw failure, (accounts) => accounts);
  }

  Future<void> createAccount(Account account) async {
    final result = await ref.read(accountRepositoryProvider).upsert(account);
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    await future;
  }
}
