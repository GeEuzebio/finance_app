import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../entities/invoice.dart';
import '../repositories/credit_card_repository.dart';

/// Quanto do saldo já está "gasto" por fatura de cartão em aberto (não
/// paga) — a parte 2 da análise de risco do Backlog (docs/ROADMAP.md):
/// "meu dinheiro serve pra pagar a fatura, e eu uso o cartão o resto do
/// mês ficando refém dele". Soma direto sobre `InvoiceItem` (não chama
/// `totalCentsForInvoice` por fatura pra evitar N+1 — mesmo padrão de
/// `project_cashflow.dart` §3). Valor sempre `<= 0` (convenção de débito).
@injectable
class GetCommittedCardBalance {
  GetCommittedCardBalance(this._repository);

  final CreditCardRepository _repository;

  Future<Either<Failure, int>> call() {
    return guardDatabase(() async {
      final invoices = await _unwrap(_repository.getAllInvoices());
      final openInvoiceIds = invoices
          .where((i) => i.status != InvoiceStatus.paga)
          .map((i) => i.id)
          .toSet();
      if (openInvoiceIds.isEmpty) return 0;

      final items = await _unwrap(_repository.getAllItems());
      return items
          .where((item) => openInvoiceIds.contains(item.invoiceId))
          .fold<int>(0, (sum, item) => sum + item.amountCents);
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
