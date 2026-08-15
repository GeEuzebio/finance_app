import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../imports/domain/entities/parsed_transaction.dart';
import '../entities/invoice_item.dart';
import '../repositories/credit_card_repository.dart';
import 'find_or_create_invoice.dart';

typedef ImportInvoiceItemsResult = ({int imported, int skipped});

/// Persiste itens de fatura já parseados de um OFX/CSV (M7, #025), mesmo
/// esquema de dedup de `ImportTransactions` mas roteando cada linha pra
/// fatura certa via `FindOrCreateInvoice`. Cada linha importada é um item
/// próprio — `installmentNumber`/`installmentTotal` sempre 1/1, pois o
/// extrato de fatura já traz cada parcela como lançamento separado.
@injectable
class ImportInvoiceItems {
  ImportInvoiceItems(this._repository, this._findOrCreateInvoice);

  final CreditCardRepository _repository;
  final FindOrCreateInvoice _findOrCreateInvoice;

  Future<Either<Failure, ImportInvoiceItemsResult>> call({
    required String creditCardId,
    required List<ParsedTransaction> parsed,
  }) {
    return guardDatabase(() async {
      final card = await _unwrap(_repository.getCardById(creditCardId));
      final existing = await _unwrap(_repository.getAllItems());
      final existingIds = existing.map((i) => i.externalId).whereType<String>().toSet();

      var imported = 0;
      var skipped = 0;
      for (final row in parsed) {
        if (existingIds.contains(row.externalId)) {
          skipped++;
          continue;
        }
        final invoice = await _unwrap(
          _findOrCreateInvoice(card: card, referenceDate: row.date),
        );
        await _unwrap(_repository.upsertItem(InvoiceItem(
          id: const Uuid().v4(),
          invoiceId: invoice.id,
          description: row.description,
          amountCents: row.amountCents,
          purchaseDate: row.date,
          installmentNumber: 1,
          installmentTotal: 1,
          purchaseGroupId: const Uuid().v4(),
          externalId: row.externalId,
          createdAt: DateTime.now(),
        )));
        imported++;
      }
      return (imported: imported, skipped: skipped);
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
