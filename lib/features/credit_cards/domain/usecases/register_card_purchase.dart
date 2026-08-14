import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../cashflow_engine/domain/installment_distribution.dart';
import '../entities/invoice_item.dart';
import '../repositories/credit_card_repository.dart';
import 'find_or_create_invoice.dart';

/// Registra uma compra (à vista ou parcelada) no cartão — um `InvoiceItem`
/// por parcela, cada uma na fatura certa (docs/CASHFLOW_ENGINE.md §3).
@injectable
class RegisterCardPurchase {
  RegisterCardPurchase(this._repository, this._findOrCreateInvoice);

  final CreditCardRepository _repository;
  final FindOrCreateInvoice _findOrCreateInvoice;

  Future<Either<Failure, Unit>> call({
    required String creditCardId,
    required String description,
    required int totalAmountCents,
    required DateOnly purchaseDate,
    required int installments,
  }) {
    return guardDatabase(() async {
      if (installments < 1) {
        throw const ValidationFailure('installments deve ser >= 1');
      }

      final card = await _unwrap(_repository.getCardById(creditCardId));
      final amounts = distributeInstallments(totalAmountCents, installments);
      final purchaseGroupId = const Uuid().v4();

      for (var i = 0; i < installments; i++) {
        final installmentDate = purchaseDate.addMonths(i);
        final invoice = await _unwrap(
          _findOrCreateInvoice(card: card, referenceDate: installmentDate),
        );
        final item = InvoiceItem(
          id: const Uuid().v4(),
          invoiceId: invoice.id,
          description: description,
          amountCents: amounts[i],
          purchaseDate: installmentDate,
          installmentNumber: i + 1,
          installmentTotal: installments,
          purchaseGroupId: purchaseGroupId,
          createdAt: DateTime.now(),
        );
        await _unwrap(_repository.upsertItem(item));
      }

      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
