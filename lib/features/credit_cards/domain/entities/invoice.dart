import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'invoice.freezed.dart';

enum InvoiceStatus { aberta, fechada, paga }

@freezed
class Invoice with _$Invoice {
  // totalCents não é campo: é agregado via SUM(amountCents) sobre
  // InvoiceItem (docs/ARCHITECTURE.md §5) — evita dessincronizar do
  // detalhe da fatura em compra nova/estorno.
  const factory Invoice({
    required String id,
    required String creditCardId,
    required String referenceMonth,
    required DateOnly closingDate,
    required DateOnly dueDate,
    required InvoiceStatus status,
    required DateTime createdAt,
  }) = _Invoice;
}
