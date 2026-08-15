import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'parsed_transaction.freezed.dart';

/// Uma linha crua extraída de um extrato OFX/CSV, antes de virar
/// `Transaction` — ainda não sabe em qual conta vai cair (M7, #023).
@freezed
class ParsedTransaction with _$ParsedTransaction {
  const factory ParsedTransaction({
    required DateOnly date,
    required String description,
    required int amountCents,
    required String externalId,
  }) = _ParsedTransaction;
}
