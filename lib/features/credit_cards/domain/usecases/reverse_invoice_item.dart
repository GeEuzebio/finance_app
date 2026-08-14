import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../entities/invoice_item.dart';
import '../repositories/credit_card_repository.dart';
import 'find_or_create_invoice.dart';

/// Estorna uma compra: cria um `InvoiceItem` com o sinal invertido, na
/// fatura vigente no momento do estorno (pode ser a mesma da compra
/// original, se ainda não fechou) — docs/CASHFLOW_ENGINE.md §3. Nunca
/// edita nem apaga o item original.
@injectable
class ReverseInvoiceItem {
  ReverseInvoiceItem(this._repository, this._findOrCreateInvoice);

  final CreditCardRepository _repository;
  final FindOrCreateInvoice _findOrCreateInvoice;

  Future<Either<Failure, Unit>> call({
    required InvoiceItem originalItem,
    required DateOnly reversalDate,
  }) {
    return guardDatabase(() async {
      final originalInvoice =
          await _unwrap(_repository.getInvoiceById(originalItem.invoiceId));
      final card = await _unwrap(_repository.getCardById(originalInvoice.creditCardId));
      final targetInvoice = await _unwrap(
        _findOrCreateInvoice(card: card, referenceDate: reversalDate),
      );

      final reversal = InvoiceItem(
        id: const Uuid().v4(),
        invoiceId: targetInvoice.id,
        description: 'Estorno: ${originalItem.description}',
        amountCents: -originalItem.amountCents,
        purchaseDate: reversalDate,
        installmentNumber: 1,
        installmentTotal: 1,
        purchaseGroupId: originalItem.purchaseGroupId,
        createdAt: DateTime.now(),
      );
      await _unwrap(_repository.upsertItem(reversal));
      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
