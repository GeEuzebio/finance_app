import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../../../accounts/domain/entities/account.dart' show AccountOwner;

const _cardsTable = 'credit_cards';
const _invoicesTable = 'invoices';
const _itemsTable = 'invoice_items';

@LazySingleton(as: CreditCardRepository)
class CreditCardRepositoryImpl implements CreditCardRepository {
  CreditCardRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<CreditCard>>> getAllCards() {
    return guardDatabase(() async {
      final rows = await _client.from(_cardsTable).select();
      return rows.map(creditCardFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, CreditCard>> getCardById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_cardsTable).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Cartão $id não encontrado');
      return creditCardFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertCard(CreditCard card) {
    return guardDatabase(() async {
      await _client.from(_cardsTable).upsert(creditCardToJson(card));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCard(String id) {
    return guardDatabase(() async {
      await _client.from(_cardsTable).delete().eq('id', id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<Invoice>>> getAllInvoices() {
    return guardDatabase(() async {
      final rows = await _client.from(_invoicesTable).select();
      return rows.map(invoiceFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Invoice>> getInvoiceById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_invoicesTable).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Fatura $id não encontrada');
      return invoiceFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertInvoice(Invoice invoice) {
    return guardDatabase(() async {
      await _client.from(_invoicesTable).upsert(invoiceToJson(invoice));
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<InvoiceItem>>> getItemsForInvoice(String invoiceId) {
    return guardDatabase(() async {
      final rows = await _client.from(_itemsTable).select().eq('invoice_id', invoiceId);
      return rows.map(invoiceItemFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, List<InvoiceItem>>> getAllItems() {
    return guardDatabase(() async {
      final rows = await _client.from(_itemsTable).select();
      return rows.map(invoiceItemFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> upsertItem(InvoiceItem item) {
    return guardDatabase(() async {
      await _client.from(_itemsTable).upsert(invoiceItemToJson(item));
      return unit;
    });
  }

  @override
  Future<Either<Failure, int>> totalCentsForInvoice(String invoiceId) {
    // ponytail: soma feita no cliente sobre os itens da fatura — o volume
    // por fatura é pequeno (compras + parcelas de um mês). Se isso crescer
    // muito, mover para uma view/RPC de agregação no Postgres.
    return guardDatabase(() async {
      final rows = await _client
          .from(_itemsTable)
          .select('amount_cents')
          .eq('invoice_id', invoiceId);
      return rows.fold<int>(0, (sum, row) => sum + (row['amount_cents'] as int));
    });
  }
}

CreditCard creditCardFromJson(Map<String, dynamic> row) => CreditCard(
      id: row['id'] as String,
      name: row['name'] as String,
      paymentAccountId: row['payment_account_id'] as String,
      closingDay: row['closing_day'] as int,
      dueDay: row['due_day'] as int,
      limitCents: row['limit_cents'] as int?,
      owner: AccountOwner.values.byName(row['owner'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> creditCardToJson(CreditCard card) => {
      'id': card.id,
      'name': card.name,
      'payment_account_id': card.paymentAccountId,
      'closing_day': card.closingDay,
      'due_day': card.dueDay,
      'limit_cents': card.limitCents,
      'owner': card.owner.name,
      'created_at': card.createdAt.toIso8601String(),
    };

Invoice invoiceFromJson(Map<String, dynamic> row) => Invoice(
      id: row['id'] as String,
      creditCardId: row['credit_card_id'] as String,
      referenceMonth: row['reference_month'] as String,
      closingDate: DateOnly.fromDateTime(DateTime.parse(row['closing_date'] as String)),
      dueDate: DateOnly.fromDateTime(DateTime.parse(row['due_date'] as String)),
      status: InvoiceStatus.values.byName(row['status'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> invoiceToJson(Invoice invoice) => {
      'id': invoice.id,
      'credit_card_id': invoice.creditCardId,
      'reference_month': invoice.referenceMonth,
      'closing_date': invoice.closingDate.toDateTime().toIso8601String().split('T').first,
      'due_date': invoice.dueDate.toDateTime().toIso8601String().split('T').first,
      'status': invoice.status.name,
      'created_at': invoice.createdAt.toIso8601String(),
    };

InvoiceItem invoiceItemFromJson(Map<String, dynamic> row) => InvoiceItem(
      id: row['id'] as String,
      invoiceId: row['invoice_id'] as String,
      description: row['description'] as String,
      amountCents: row['amount_cents'] as int,
      purchaseDate: DateOnly.fromDateTime(DateTime.parse(row['purchase_date'] as String)),
      installmentNumber: row['installment_number'] as int,
      installmentTotal: row['installment_total'] as int,
      purchaseGroupId: row['purchase_group_id'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> invoiceItemToJson(InvoiceItem item) => {
      'id': item.id,
      'invoice_id': item.invoiceId,
      'description': item.description,
      'amount_cents': item.amountCents,
      'purchase_date': item.purchaseDate.toDateTime().toIso8601String().split('T').first,
      'installment_number': item.installmentNumber,
      'installment_total': item.installmentTotal,
      'purchase_group_id': item.purchaseGroupId,
      'created_at': item.createdAt.toIso8601String(),
    };
