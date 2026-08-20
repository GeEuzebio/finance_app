import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../cashflow_engine/domain/recurrence_expansion.dart';
import '../entities/check_in_item.dart';
import '../entities/transaction.dart';
import '../repositories/recurrence_repository.dart';
import '../repositories/transaction_repository.dart';

/// Junta `Transaction`s reais (`previsto`, hoje) com ocorrências virtuais
/// de `RecurrenceRule` que caem hoje e ainda não têm override — a lista
/// que a tela de Check-in Diário mostra (pilar 2, docs/CASHFLOW_ENGINE.md).
@injectable
class GetTodayCheckInItems {
  GetTodayCheckInItems(this._accounts, this._transactions, this._recurrences);

  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final RecurrenceRepository _recurrences;

  Future<Either<Failure, List<CheckInItem>>> call({required DateOnly today}) {
    return guardDatabase(() async {
      final accounts = await _unwrap(_accounts.getAll());
      final accountNames = {for (final a in accounts) a.id: a.name};

      final transactions = await _unwrap(_transactions.getAll());

      final materialized = transactions
          .where((t) => t.date == today && t.status == TransactionStatus.previsto)
          .map((t) => CheckInItem(
                transactionId: t.id,
                accountId: t.accountId,
                accountName: accountNames[t.accountId] ?? '—',
                description: t.description,
                amountCents: t.amountCents,
                date: t.date,
                category: t.category,
                recurrenceRuleId: t.recurrenceRuleId,
                createdAt: t.createdAt,
              ));

      // Qualquer Transaction vinculada à regra hoje (previsto, confirmado,
      // ajustado, adiado ou cancelado) já resolveu a ocorrência — a
      // virtual não deve aparecer de novo (mesma lógica de
      // project_cashflow.dart, passo 2, aplicada a um único dia).
      final resolvedRuleIds = transactions
          .where((t) => t.recurrenceRuleId != null && t.date == today)
          .map((t) => t.recurrenceRuleId)
          .toSet();

      final rules = await _unwrap(_recurrences.getAll());
      final virtual = rules
          .where((r) => !resolvedRuleIds.contains(r.id))
          .where((r) => expandRecurrence(r, today, today).isNotEmpty)
          .map((r) => CheckInItem(
                accountId: r.accountId,
                accountName: accountNames[r.accountId] ?? '—',
                description: r.description,
                amountCents: r.amountCents,
                date: today,
                category: r.category,
                recurrenceRuleId: r.id,
              ));

      return [...materialized, ...virtual];
    });
  }
}

Future<T> _unwrap<T>(Future<Either<Failure, T>> future) async =>
    (await future).match((failure) => throw failure, (value) => value);
