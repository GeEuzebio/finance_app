import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../entities/credit_card.dart';
import '../entities/invoice.dart';
import '../entities/invoice_item.dart';

/// Cobre os três entidades do cluster de cartão (`CreditCard`, `Invoice`,
/// `InvoiceItem`) num único repositório — são consultadas e escritas juntas
/// na prática (docs/ARCHITECTURE.md §3, árvore de `features/credit_cards`).
abstract class CreditCardRepository {
  Future<Either<Failure, List<CreditCard>>> getAllCards();
  Future<Either<Failure, CreditCard>> getCardById(String id);
  Future<Either<Failure, Unit>> upsertCard(CreditCard card);
  Future<Either<Failure, Unit>> deleteCard(String id);

  Future<Either<Failure, List<Invoice>>> getAllInvoices();
  Future<Either<Failure, Invoice>> getInvoiceById(String id);
  Future<Either<Failure, Unit>> upsertInvoice(Invoice invoice);

  Future<Either<Failure, List<InvoiceItem>>> getItemsForInvoice(String invoiceId);
  Future<Either<Failure, Unit>> upsertItem(InvoiceItem item);

  /// Soma de `amountCents` de todos os itens da fatura — `Invoice.totalCents`
  /// nunca é uma coluna persistida (docs/ARCHITECTURE.md §5).
  Future<Either<Failure, int>> totalCentsForInvoice(String invoiceId);
}
