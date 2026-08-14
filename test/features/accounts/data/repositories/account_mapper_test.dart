import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finance_app/features/accounts/domain/entities/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final account = Account(
    id: 'a1',
    name: 'Conta corrente',
    type: AccountType.checking,
    owner: AccountOwner.conjunta,
    initialBalanceCents: 100000,
    initialBalanceDate: DateOnly(2026, 1, 1),
    archived: false,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  test('accountToJson usa nomes de coluna snake_case e enums como string', () {
    final json = accountToJson(account);

    expect(json['id'], 'a1');
    expect(json['type'], 'checking');
    expect(json['owner'], 'conjunta');
    expect(json['initial_balance_cents'], 100000);
    expect(json['initial_balance_date'], '2026-01-01');
    expect(json['archived'], false);
  });

  test('accountFromJson(accountToJson(x)) faz roundtrip sem perda', () {
    final restored = accountFromJson(accountToJson(account));

    expect(restored, account);
  });
}
