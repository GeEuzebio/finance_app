import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'check_in_item.freezed.dart';

/// Uma previsão de hoje pronta pro check-in (pilar 2) — pode já existir
/// como `Transaction` (`transactionId` preenchido) ou ainda ser só uma
/// ocorrência virtual de uma `RecurrenceRule` que nunca foi materializada
/// (`transactionId` nulo, `recurrenceRuleId` preenchido). Confirmar,
/// ajustar, adiar ou cancelar materializa a virtual — nunca edita a
/// `RecurrenceRule` (docs/CASHFLOW_ENGINE.md §3).
@freezed
class CheckInItem with _$CheckInItem {
  const factory CheckInItem({
    String? transactionId,
    required String accountId,
    required String accountName,
    required String description,
    required int amountCents,
    required DateOnly date,
    String? recurrenceRuleId,
    // null pra item ainda virtual — materializar usa DateTime.now() nesse
    // caso; preservado ao reeditar um item já materializado, pra não
    // corromper o createdAt original da Transaction real.
    DateTime? createdAt,
  }) = _CheckInItem;

  const CheckInItem._();

  /// Id da `Transaction` a criar/atualizar pra materializar este item —
  /// a existente, se já materializado, ou o id determinístico do slot de
  /// override da regra (`recurrenceOverrideId`, usado pelos casos de uso
  /// de check-in em vez de importar isso aqui pra não acoplar a entidade
  /// à camada de uuid).
  bool get isVirtual => transactionId == null;
}
