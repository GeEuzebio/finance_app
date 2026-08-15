import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../../credit_cards/domain/usecases/import_invoice_items.dart';
import '../../credit_cards/presentation/credit_cards_providers.dart';
import '../../transactions/presentation/lancamentos_providers.dart';
import '../domain/entities/parsed_transaction.dart';
import '../domain/usecases/import_transactions.dart';

part 'import_providers.g.dart';

@riverpod
ImportTransactions importTransactionsUseCase(Ref ref) => getIt<ImportTransactions>();
@riverpod
ImportInvoiceItems importInvoiceItemsUseCase(Ref ref) => getIt<ImportInvoiceItems>();

@riverpod
class ImportController extends _$ImportController {
  @override
  void build() {}

  Future<ImportResult> import({
    required String accountId,
    required List<ParsedTransaction> parsed,
  }) async {
    final result = await ref.read(importTransactionsUseCaseProvider).call(
          accountId: accountId,
          parsed: parsed,
        );
    final imported = result.match((failure) => throw failure, (value) => value);
    ref.invalidate(lancamentosControllerProvider);
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    return imported;
  }

  Future<ImportInvoiceItemsResult> importInvoice({
    required String creditCardId,
    required List<ParsedTransaction> parsed,
  }) async {
    final result = await ref.read(importInvoiceItemsUseCaseProvider).call(
          creditCardId: creditCardId,
          parsed: parsed,
        );
    final imported = result.match((failure) => throw failure, (value) => value);
    ref.invalidate(cardDetailControllerProvider(creditCardId));
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    ref.invalidate(committedCardBalanceProvider);
    return imported;
  }
}
