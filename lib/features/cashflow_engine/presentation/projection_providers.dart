import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/date_only.dart';
import '../domain/entities/daily_balance.dart';
import '../domain/usecases/get_daily_projection.dart';

part 'projection_providers.g.dart';

@riverpod
GetDailyProjection getDailyProjectionUseCase(Ref ref) => getIt<GetDailyProjection>();

/// Horizonte fixo de 30 dias a partir de hoje — suficiente pro check-in do
/// dia a dia; horizonte de 12 meses (docs/CASHFLOW_ENGINE.md) fica pra uma
/// visão de longo prazo futura, não pra essa lista.
@riverpod
Future<List<DailyBalance>> dailyProjection(Ref ref) async {
  final today = DateOnly.fromDateTime(DateTime.now());
  final result = await ref.read(getDailyProjectionUseCaseProvider).call(
        horizonStart: today,
        horizonEnd: today.addDays(30),
      );
  return result.match((failure) => throw failure, (balances) => balances);
}
