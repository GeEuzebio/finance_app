import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/date_only.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

const _table = 'accounts';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<Account>>> getAll() {
    return guardDatabase(() async {
      final rows = await _client.from(_table).select();
      return rows.map(accountFromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Account>> getById(String id) {
    return guardDatabase(() async {
      final row = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (row == null) throw NotFoundFailure('Conta $id não encontrada');
      return accountFromJson(row);
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(Account account) {
    return guardDatabase(() async {
      await _client.from(_table).upsert(accountToJson(account));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) {
    return guardDatabase(() async {
      await _client.from(_table).delete().eq('id', id);
      return unit;
    });
  }
}

/// Mapeamento puro linha↔entidade — testável sem conexão de rede
/// (ver test/features/accounts/data/repositories/account_mapper_test.dart).
Account accountFromJson(Map<String, dynamic> row) => Account(
      id: row['id'] as String,
      name: row['name'] as String,
      type: AccountType.values.byName(row['type'] as String),
      owner: AccountOwner.values.byName(row['owner'] as String),
      initialBalanceCents: row['initial_balance_cents'] as int,
      initialBalanceDate:
          DateOnly.fromDateTime(DateTime.parse(row['initial_balance_date'] as String)),
      archived: row['archived'] as bool,
      createdAt: DateTime.parse(row['created_at'] as String),
    );

Map<String, dynamic> accountToJson(Account account) => {
      'id': account.id,
      'name': account.name,
      'type': account.type.name,
      'owner': account.owner.name,
      'initial_balance_cents': account.initialBalanceCents,
      'initial_balance_date': _dateOnlyJson(account.initialBalanceDate),
      'archived': account.archived,
      'created_at': account.createdAt.toIso8601String(),
    };

String _dateOnlyJson(DateOnly date) => date.toDateTime().toIso8601String().split('T').first;
