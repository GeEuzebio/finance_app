import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../cashflow_engine/domain/invoice_cycle.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';
import '../repositories/credit_card_repository.dart';

/// Acha a fatura do ciclo de [referenceDate] pra esse cartão, ou cria uma
/// nova se ainda não existir — usado por `RegisterCardPurchase` e
/// `ReverseInvoiceItem` pra concordarem sobre "qual fatura é essa" sem
/// duplicar a regra de fechamento (docs/CASHFLOW_ENGINE.md §3).
@injectable
class FindOrCreateInvoice {
  FindOrCreateInvoice(this._repository);

  final CreditCardRepository _repository;

  Future<Either<Failure, Invoice>> call({
    required CreditCard card,
    required DateOnly referenceDate,
  }) {
    return guardDatabase(() async {
      final cycle = resolveInvoiceCycle(referenceDate, card.closingDay);
      final referenceMonth =
          '${cycle.year}-${cycle.month.toString().padLeft(2, '0')}';

      final invoices = await _unwrap(_repository.getAllInvoices());
      final existing = invoices.where(
        (i) => i.creditCardId == card.id && i.referenceMonth == referenceMonth,
      );
      if (existing.isNotEmpty) return existing.first;

      final newInvoice = Invoice(
        id: const Uuid().v4(),
        creditCardId: card.id,
        referenceMonth: referenceMonth,
        closingDate: clampedMonthDate(cycle.year, cycle.month, card.closingDay),
        dueDate: _dueDateFor(cycle, card),
        status: InvoiceStatus.aberta,
        createdAt: DateTime.now(),
      );
      await _unwrap(_repository.upsertInvoice(newInvoice));
      return newInvoice;
    });
  }

  // ⚠️ SUPOSIÇÃO (docs/CASHFLOW_ENGINE.md §3): dueDate cai no mesmo mês do
  // fechamento se dueDay >= closingDay; se dueDay < closingDay, cai no mês
  // seguinte (padrão comum de fatura brasileira — fecha dia 25, vence dia 5
  // do mês seguinte).
  DateOnly _dueDateFor(({int year, int month}) cycle, CreditCard card) {
    if (card.dueDay >= card.closingDay) {
      return clampedMonthDate(cycle.year, cycle.month, card.dueDay);
    }
    final nextMonth = cycle.month == 12 ? 1 : cycle.month + 1;
    final nextYear = cycle.month == 12 ? cycle.year + 1 : cycle.year;
    return clampedMonthDate(nextYear, nextMonth, card.dueDay);
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
