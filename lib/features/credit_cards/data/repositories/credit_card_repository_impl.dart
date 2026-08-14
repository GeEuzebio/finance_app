import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/credit_cards_dao.dart';
import '../../../../core/database/daos/invoice_items_dao.dart';
import '../../../../core/database/daos/invoices_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../domain/repositories/credit_card_repository.dart';

@LazySingleton(as: CreditCardRepository)
class CreditCardRepositoryImpl implements CreditCardRepository {
  CreditCardRepositoryImpl(this._cardsDao, this._invoicesDao, this._itemsDao);

  final CreditCardsDao _cardsDao;
  final InvoicesDao _invoicesDao;
  final InvoiceItemsDao _itemsDao;

  @override
  Future<Either<Failure, List<CreditCard>>> getAllCards() {
    return guardDatabase(() async {
      final rows = await _cardsDao.getAll();
      return rows.map(_cardToEntity).toList();
    });
  }

  @override
  Future<Either<Failure, CreditCard>> getCardById(String id) {
    return guardDatabase(() async {
      final row = await _cardsDao.getById(id);
      if (row == null) throw NotFoundFailure('Cartão $id não encontrado');
      return _cardToEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertCard(CreditCard card) {
    return guardDatabase(() async {
      await _cardsDao.upsert(_cardToCompanion(card));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCard(String id) {
    return guardDatabase(() async {
      await _cardsDao.deleteById(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<Invoice>>> getAllInvoices() {
    return guardDatabase(() async {
      final rows = await _invoicesDao.getAll();
      return rows.map(_invoiceToEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Invoice>> getInvoiceById(String id) {
    return guardDatabase(() async {
      final row = await _invoicesDao.getById(id);
      if (row == null) throw NotFoundFailure('Fatura $id não encontrada');
      return _invoiceToEntity(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertInvoice(Invoice invoice) {
    return guardDatabase(() async {
      await _invoicesDao.upsert(_invoiceToCompanion(invoice));
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<InvoiceItem>>> getItemsForInvoice(String invoiceId) {
    return guardDatabase(() async {
      final rows = await _itemsDao.getForInvoice(invoiceId);
      return rows.map(_itemToEntity).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertItem(InvoiceItem item) {
    return guardDatabase(() async {
      await _itemsDao.upsert(_itemToCompanion(item));
      return unit;
    });
  }

  @override
  Future<Either<Failure, int>> totalCentsForInvoice(String invoiceId) {
    return guardDatabase(() => _itemsDao.totalCentsForInvoice(invoiceId));
  }

  CreditCard _cardToEntity(db.CreditCard row) => CreditCard(
        id: row.id,
        name: row.name,
        paymentAccountId: row.paymentAccountId,
        closingDay: row.closingDay,
        dueDay: row.dueDay,
        limitCents: row.limitCents,
        owner: row.owner,
        createdAt: row.createdAt,
      );

  db.CreditCardsCompanion _cardToCompanion(CreditCard card) =>
      db.CreditCardsCompanion.insert(
        id: card.id,
        name: card.name,
        paymentAccountId: card.paymentAccountId,
        closingDay: card.closingDay,
        dueDay: card.dueDay,
        limitCents: Value(card.limitCents),
        owner: card.owner,
        createdAt: card.createdAt,
      );

  Invoice _invoiceToEntity(db.Invoice row) => Invoice(
        id: row.id,
        creditCardId: row.creditCardId,
        referenceMonth: row.referenceMonth,
        closingDate: DateOnly.fromDateTime(row.closingDate),
        dueDate: DateOnly.fromDateTime(row.dueDate),
        status: row.status,
        createdAt: row.createdAt,
      );

  db.InvoicesCompanion _invoiceToCompanion(Invoice invoice) =>
      db.InvoicesCompanion.insert(
        id: invoice.id,
        creditCardId: invoice.creditCardId,
        referenceMonth: invoice.referenceMonth,
        closingDate: invoice.closingDate.toDateTime(),
        dueDate: invoice.dueDate.toDateTime(),
        status: invoice.status,
        createdAt: invoice.createdAt,
      );

  InvoiceItem _itemToEntity(db.InvoiceItem row) => InvoiceItem(
        id: row.id,
        invoiceId: row.invoiceId,
        description: row.description,
        amountCents: row.amountCents,
        purchaseDate: DateOnly.fromDateTime(row.purchaseDate),
        installmentNumber: row.installmentNumber,
        installmentTotal: row.installmentTotal,
        purchaseGroupId: row.purchaseGroupId,
        createdAt: row.createdAt,
      );

  db.InvoiceItemsCompanion _itemToCompanion(InvoiceItem item) =>
      db.InvoiceItemsCompanion.insert(
        id: item.id,
        invoiceId: item.invoiceId,
        description: item.description,
        amountCents: item.amountCents,
        purchaseDate: item.purchaseDate.toDateTime(),
        installmentNumber: item.installmentNumber,
        installmentTotal: item.installmentTotal,
        purchaseGroupId: item.purchaseGroupId,
        createdAt: item.createdAt,
      );
}
