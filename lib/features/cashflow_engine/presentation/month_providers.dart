import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/date_only.dart';
import '../../settings/presentation/settings_providers.dart';
import '../domain/entities/monthly_summary.dart';
import '../domain/usecases/get_monthly_summary.dart';

part 'month_providers.g.dart';

@riverpod
GetMonthlySummary getMonthlySummaryUseCase(Ref ref) => getIt<GetMonthlySummary>();

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
