import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'daily_balance.freezed.dart';

/// Não é uma tabela Drift — é o tipo de retorno em memória da engine de
/// projeção (pura, recalculada sob demanda, nunca persistida).
/// `accountId == null` marca a linha consolidada do dia.
/// `freeBalanceCents` só é preenchido na linha consolidada (reservas não
/// são por conta — docs/CASHFLOW_ENGINE.md §2 passo 7).
@freezed
class DailyBalance with _$DailyBalance {
  const factory DailyBalance({
    required DateOnly date,
    String? accountId,
    required int openingBalanceCents,
    required int closingBalanceCents,
    required int projectedCreditsCents,
    required int projectedDebitsCents,
    int? freeBalanceCents,
  }) = _DailyBalance;
}
