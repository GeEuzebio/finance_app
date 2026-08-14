import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'account_snapshot.freezed.dart';

/// Visão mínima de uma conta necessária para a engine de projeção
/// (docs/CASHFLOW_ENGINE.md §1) — não é a entidade `Account` completa.
@freezed
class AccountSnapshot with _$AccountSnapshot {
  const factory AccountSnapshot({
    required String id,
    required int initialBalanceCents,
    required DateOnly initialBalanceDate,
    required bool archived,
  }) = _AccountSnapshot;
}
