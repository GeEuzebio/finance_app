import '../../../core/utils/date_only.dart';

/// Mês de referência (ano + mês) da fatura em que uma compra cai, dado o
/// dia de fechamento do cartão. Compra até o fechamento (inclusive) cai no
/// ciclo atual; após, no ciclo seguinte (docs/CASHFLOW_ENGINE.md §3).
({int year, int month}) resolveInvoiceCycle(
  DateOnly purchaseDate,
  int closingDay,
) {
  if (purchaseDate.day <= closingDay) {
    return (year: purchaseDate.year, month: purchaseDate.month);
  }
  final nextMonth = purchaseDate.month == 12 ? 1 : purchaseDate.month + 1;
  final nextYear =
      purchaseDate.month == 12 ? purchaseDate.year + 1 : purchaseDate.year;
  return (year: nextYear, month: nextMonth);
}
