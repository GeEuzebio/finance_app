import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'invoice_item.freezed.dart';

@freezed
class InvoiceItem with _$InvoiceItem {
  const factory InvoiceItem({
    required String id,
    required String invoiceId,
    required String description,
    required int amountCents,
    required DateOnly purchaseDate,
    required int installmentNumber,
    required int installmentTotal,
    required String purchaseGroupId,
    required DateTime createdAt,
  }) = _InvoiceItem;
}
