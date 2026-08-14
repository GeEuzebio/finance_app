import 'package:freezed_annotation/freezed_annotation.dart';

part 'reserve.freezed.dart';

@freezed
class Reserve with _$Reserve {
  const factory Reserve({
    required String id,
    required String name,
    int? targetAmountCents,
    required int currentAmountCents,
    required DateTime createdAt,
  }) = _Reserve;
}
