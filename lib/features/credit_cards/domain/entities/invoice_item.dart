import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';
import '../../../../core/utils/transaction_category.dart';

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
    // Preenchido só em itens vindos de importação de fatura OFX/CSV
    // (M7, #025) — usado pra deduplicar reimportação do mesmo período.
    // `null` em todo o resto do app.
    String? externalId,
    // Pra onde foi o gasto, não como foi pago (M7, #029). Itens de
    // importação (OFX/CSV) ficam em 'outros' — não dá pra inferir
    // categoria de um extrato de fatura automaticamente.
    @Default(TransactionCategory.outros) TransactionCategory category,
    required DateTime createdAt,
  }) = _InvoiceItem;
}
