import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/invoice.dart' show InvoiceStatus;
import '../repositories/credit_card_repository.dart';

/// Marca uma fatura como paga. Se o total for zero (estornado por
/// completo), não gera `Transaction` nenhuma — só a fatura muda de status
/// (docs/CASHFLOW_ENGINE.md caso de teste #15). Caso contrário, a
/// `Transaction` concreta criada aqui (`invoicePaymentForId` preenchido) é
/// o que faz a engine parar de sintetizar um débito virtual pra essa
/// fatura (CASHFLOW_ENGINE.md §2 passo 3).
@injectable
class PayInvoice {
  PayInvoice(this._cardRepository, this._transactionRepository);

  final CreditCardRepository _cardRepository;
  final TransactionRepository _transactionRepository;

  Future<Either<Failure, Unit>> call({
    required String invoiceId,
    required DateOnly paymentDate,
  }) {
    return guardDatabase(() async {
      final invoice = await _unwrap(_cardRepository.getInvoiceById(invoiceId));
      final total = await _unwrap(_cardRepository.totalCentsForInvoice(invoiceId));

      if (total != 0) {
        final card = await _unwrap(_cardRepository.getCardById(invoice.creditCardId));
        final now = DateTime.now();
        final payment = Transaction(
          id: const Uuid().v4(),
          accountId: card.paymentAccountId,
          description: 'Pagamento fatura ${invoice.referenceMonth}',
          amountCents: total,
          date: paymentDate,
          status: TransactionStatus.confirmado,
          invoicePaymentForId: invoice.id,
          createdAt: now,
          updatedAt: now,
        );
        await _unwrap(_transactionRepository.upsert(payment));
      }

      await _unwrap(
        _cardRepository.upsertInvoice(invoice.copyWith(status: InvoiceStatus.paga)),
      );
      return unit;
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
