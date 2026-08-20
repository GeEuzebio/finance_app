import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../entities/invoice.dart';
import '../repositories/credit_card_repository.dart';

/// Quanto está em rotativo de verdade — fatura com vencimento **já
/// passado** e ainda não paga (M7, #029, plano de quitação). Diferente
/// de `GetCommittedCardBalance` (soma toda fatura em aberto, mesmo a que
/// ainda nem venceu): aqui só entra o que já devia ter sido pago e não
/// foi, sinal de que o cartão virou dívida, não só gasto do mês. Valor
/// sempre `<= 0` (convenção de débito).
@injectable
class GetOverdueCardDebt {
  GetOverdueCardDebt(this._repository);

  final CreditCardRepository _repository;

  Future<Either<Failure, int>> call({required DateOnly today}) {
    return guardDatabase(() async {
      final invoices = await _unwrap(_repository.getAllInvoices());
      final overdueInvoiceIds = invoices
          .where((i) => i.status != InvoiceStatus.paga)
          .where((i) => i.dueDate.isBefore(today))
          .map((i) => i.id)
          .toSet();
      if (overdueInvoiceIds.isEmpty) return 0;

      final items = await _unwrap(_repository.getAllItems());
      return items
          .where((item) => overdueInvoiceIds.contains(item.invoiceId))
          .fold<int>(0, (sum, item) => sum + item.amountCents);
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
