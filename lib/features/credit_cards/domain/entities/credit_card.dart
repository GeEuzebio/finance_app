import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../accounts/domain/entities/account.dart';

part 'credit_card.freezed.dart';

@freezed
class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String id,
    required String name,
    required String paymentAccountId,
    required int closingDay,
    required int dueDay,
    int? limitCents,
    required AccountOwner owner,
    required DateTime createdAt,
  }) = _CreditCard;
}
