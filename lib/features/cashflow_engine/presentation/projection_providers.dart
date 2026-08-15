import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/date_only.dart';
import '../../credit_cards/domain/usecases/get_committed_card_balance.dart';
import '../../transactions/domain/entities/check_in_item.dart';
import '../../transactions/domain/usecases/get_day_ledger.dart';
import '../domain/entities/daily_balance.dart';
import '../domain/usecases/get_daily_projection.dart';

part 'projection_providers.g.dart';

@riverpod
GetDailyProjection getDailyProjectionUseCase(Ref ref) => getIt<GetDailyProjection>();
@riverpod
GetCommittedCardBalance getCommittedCardBalanceUseCase(Ref ref) =>
    getIt<GetCommittedCardBalance>();
@riverpod
GetDayLedger getDayLedgerUseCase(Ref ref) => getIt<GetDayLedger>();

/// Quanto do saldo de hoje já está comprometido com fatura de cartão em
/// aberto (Backlog, "análise de risco" parte 2 — docs/ROADMAP.md). É um
/// retrato de agora, não um valor por dia da projeção: a própria engine
/// já sintetiza o débito da fatura na data de vencimento
/// (`project_cashflow.dart` §3), então aplicar esse desconto em todo dia
/// do horizonte contaria a mesma fatura duas vezes a partir do
/// vencimento.
@riverpod
Future<int> committedCardBalance(Ref ref) async {
  final result = await ref.read(getCommittedCardBalanceUseCaseProvider).call();
  return result.match((failure) => throw failure, (value) => value);
}

/// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
/// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
/// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
/// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
@riverpod
Future<List<DailyBalance>> monthlyProjection(Ref ref, {required int year, required int month}) async {
  final start = DateOnly(year, month, 1);
  final end = clampedMonthDate(year, month, 31);
  final result = await ref.read(getDailyProjectionUseCaseProvider).call(
        horizonStart: start,
        horizonEnd: end,
      );
  return result.match((failure) => throw failure, (balances) => balances);
}

/// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
/// como "Diferença", item a item.
@riverpod
Future<List<CheckInItem>> dayLedger(Ref ref, {required DateOnly day}) async {
  final result = await ref.read(getDayLedgerUseCaseProvider).call(day: day);
  return result.match((failure) => throw failure, (items) => items);
}
