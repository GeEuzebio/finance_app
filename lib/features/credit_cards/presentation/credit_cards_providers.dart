import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/date_only.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/credit_card.dart';
import '../domain/entities/invoice.dart';
import '../domain/entities/invoice_item.dart';
import '../domain/repositories/credit_card_repository.dart';
import '../domain/usecases/find_or_create_invoice.dart';
import '../domain/usecases/pay_invoice.dart';
import '../domain/usecases/register_card_purchase.dart';
import '../domain/usecases/reverse_invoice_item.dart';

part 'credit_cards_providers.g.dart';

typedef CardDetail = ({
  CreditCard card,
  Invoice invoice,
  List<InvoiceItem> items,
  int totalCents,
});

@riverpod
CreditCardRepository creditCardRepository(Ref ref) => getIt<CreditCardRepository>();
@riverpod
FindOrCreateInvoice findOrCreateInvoiceUseCase(Ref ref) => getIt<FindOrCreateInvoice>();
@riverpod
RegisterCardPurchase registerCardPurchaseUseCase(Ref ref) => getIt<RegisterCardPurchase>();
@riverpod
PayInvoice payInvoiceUseCase(Ref ref) => getIt<PayInvoice>();
@riverpod
ReverseInvoiceItem reverseInvoiceItemUseCase(Ref ref) => getIt<ReverseInvoiceItem>();

@riverpod
class CreditCardsController extends _$CreditCardsController {
  @override
  Future<List<CreditCard>> build() async {
    final result = await ref.read(creditCardRepositoryProvider).getAllCards();
    return result.match((failure) => throw failure, (cards) => cards);
  }

  Future<void> createCard(CreditCard card) async {
    final result = await ref.read(creditCardRepositoryProvider).upsertCard(card);
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class CardDetailController extends _$CardDetailController {
  @override
  Future<CardDetail> build(String cardId) async {
    final repository = ref.read(creditCardRepositoryProvider);
    final card = await _unwrap(repository.getCardById(cardId));
    final invoice = await _unwrap(
      ref.read(findOrCreateInvoiceUseCaseProvider).call(
            card: card,
            referenceDate: DateOnly.fromDateTime(DateTime.now()),
          ),
    );
    final items = await _unwrap(repository.getItemsForInvoice(invoice.id));
    final total = await _unwrap(repository.totalCentsForInvoice(invoice.id));
    return (card: card, invoice: invoice, items: items, totalCents: total);
  }

  Future<void> registerPurchase({
    required String description,
    required int amountCents,
    required DateOnly purchaseDate,
    required int installments,
  }) =>
      _run(() => ref.read(registerCardPurchaseUseCaseProvider).call(
            creditCardId: cardId,
            description: description,
            totalAmountCents: amountCents,
            purchaseDate: purchaseDate,
            installments: installments,
          ));

  Future<void> payInvoice() async {
    final current = await future;
    await _run(() => ref.read(payInvoiceUseCaseProvider).call(
          invoiceId: current.invoice.id,
          paymentDate: DateOnly.fromDateTime(DateTime.now()),
        ));
  }

  Future<void> reverseItem(InvoiceItem item) => _run(() => ref
      .read(reverseInvoiceItemUseCaseProvider)
      .call(originalItem: item, reversalDate: DateOnly.fromDateTime(DateTime.now())));

  Future<void> _run(Future<Either<Failure, Unit>> Function() action) async {
    final result = await action();
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    ref.invalidate(committedCardBalanceProvider);
    await future;
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
