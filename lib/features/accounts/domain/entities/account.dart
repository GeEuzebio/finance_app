import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only.dart';

part 'account.freezed.dart';

enum AccountType { checking, savings, wallet, other }

/// Dono da conta — app é compartilhado entre o usuário e o cônjuge em um
/// único banco (docs/ARCHITECTURE.md §1).
enum AccountOwner { eu, conjuge, conjunta }

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    required AccountOwner owner,
    required int initialBalanceCents,
    required DateOnly initialBalanceDate,
    required bool archived,
    required DateTime createdAt,
  }) = _Account;
}
