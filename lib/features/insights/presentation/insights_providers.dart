import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../cashflow_engine/domain/monthly_summary.dart';
import '../../cashflow_engine/presentation/month_providers.dart';
import '../domain/entities/financial_insights.dart';
import '../domain/usecases/generate_financial_insights.dart';

part 'insights_providers.g.dart';

@riverpod
GenerateFinancialInsights generateFinancialInsightsUseCase(Ref ref) =>
    getIt<GenerateFinancialInsights>();

// ponytail: estado só em memória, gera de novo a cada sessão — sem
// tabela de cache; persistir só se a re-geração incomodar na prática.
@riverpod
class InsightsController extends _$InsightsController {
  @override
  FinancialInsights? build() => null;

  Future<void> generate() async {
    final summary = await ref.read(monthlySummaryProvider.future);
    final overdueCents = await ref.read(overdueCardDebtProvider.future);
    final budget = budget503020(summary);

    final result = await ref.read(generateFinancialInsightsUseCaseProvider).call((
      categoryCents: summary.categoryCents,
      necessidadesCents: budget.necessidadesCents,
      desejosCents: budget.desejosCents,
      reservaCents: budget.reservaCents,
      savedCents: summary.savedCents,
      savingsPercent: summary.savingsPercent,
      overdueCents: overdueCents,
    ));
    state = result.match((failure) => throw failure, (insights) => insights);
  }
}
