import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/date_only.dart';
import '../../credit_cards/domain/usecases/get_overdue_card_debt.dart';
import '../../settings/presentation/settings_providers.dart';
import '../domain/entities/monthly_summary.dart';
import '../domain/usecases/get_monthly_summary.dart';

part 'month_providers.g.dart';

@riverpod
GetMonthlySummary getMonthlySummaryUseCase(Ref ref) => getIt<GetMonthlySummary>();
@riverpod
GetOverdueCardDebt getOverdueCardDebtUseCase(Ref ref) => getIt<GetOverdueCardDebt>();

@riverpod
Future<MonthlySummary> monthlySummary(Ref ref) async {
  final settings = await ref.watch(settingsControllerProvider.future);
  final today = DateOnly.fromDateTime(DateTime.now());
  final result = await ref.read(getMonthlySummaryUseCaseProvider).call(
        year: today.year,
        month: today.month,
        savingsTargetPercent: settings.savingsTargetPercent,
      );
  return result.match((failure) => throw failure, (summary) => summary);
}

/// Dívida de fatura atrasada (M7, #029, plano de quitação) — `<= 0`,
/// mesma convenção de débito de `committedCardBalanceProvider`.
@riverpod
Future<int> overdueCardDebt(Ref ref) async {
  final today = DateOnly.fromDateTime(DateTime.now());
  final result = await ref.read(getOverdueCardDebtUseCaseProvider).call(today: today);
  return result.match((failure) => throw failure, (value) => value);
}
