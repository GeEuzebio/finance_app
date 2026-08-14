// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyBalance {
  DateOnly get date => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;
  int get openingBalanceCents => throw _privateConstructorUsedError;
  int get closingBalanceCents => throw _privateConstructorUsedError;
  int get projectedCreditsCents => throw _privateConstructorUsedError;
  int get projectedDebitsCents => throw _privateConstructorUsedError;
  int? get freeBalanceCents => throw _privateConstructorUsedError;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyBalanceCopyWith<DailyBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyBalanceCopyWith<$Res> {
  factory $DailyBalanceCopyWith(
          DailyBalance value, $Res Function(DailyBalance) then) =
      _$DailyBalanceCopyWithImpl<$Res, DailyBalance>;
  @useResult
  $Res call(
      {DateOnly date,
      String? accountId,
      int openingBalanceCents,
      int closingBalanceCents,
      int projectedCreditsCents,
      int projectedDebitsCents,
      int? freeBalanceCents});
}

/// @nodoc
class _$DailyBalanceCopyWithImpl<$Res, $Val extends DailyBalance>
    implements $DailyBalanceCopyWith<$Res> {
  _$DailyBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? accountId = freezed,
    Object? openingBalanceCents = null,
    Object? closingBalanceCents = null,
    Object? projectedCreditsCents = null,
    Object? projectedDebitsCents = null,
    Object? freeBalanceCents = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      openingBalanceCents: null == openingBalanceCents
          ? _value.openingBalanceCents
          : openingBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceCents: null == closingBalanceCents
          ? _value.closingBalanceCents
          : closingBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      projectedCreditsCents: null == projectedCreditsCents
          ? _value.projectedCreditsCents
          : projectedCreditsCents // ignore: cast_nullable_to_non_nullable
              as int,
      projectedDebitsCents: null == projectedDebitsCents
          ? _value.projectedDebitsCents
          : projectedDebitsCents // ignore: cast_nullable_to_non_nullable
              as int,
      freeBalanceCents: freezed == freeBalanceCents
          ? _value.freeBalanceCents
          : freeBalanceCents // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyBalanceImplCopyWith<$Res>
    implements $DailyBalanceCopyWith<$Res> {
  factory _$$DailyBalanceImplCopyWith(
          _$DailyBalanceImpl value, $Res Function(_$DailyBalanceImpl) then) =
      __$$DailyBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateOnly date,
      String? accountId,
      int openingBalanceCents,
      int closingBalanceCents,
      int projectedCreditsCents,
      int projectedDebitsCents,
      int? freeBalanceCents});
}

/// @nodoc
class __$$DailyBalanceImplCopyWithImpl<$Res>
    extends _$DailyBalanceCopyWithImpl<$Res, _$DailyBalanceImpl>
    implements _$$DailyBalanceImplCopyWith<$Res> {
  __$$DailyBalanceImplCopyWithImpl(
      _$DailyBalanceImpl _value, $Res Function(_$DailyBalanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? accountId = freezed,
    Object? openingBalanceCents = null,
    Object? closingBalanceCents = null,
    Object? projectedCreditsCents = null,
    Object? projectedDebitsCents = null,
    Object? freeBalanceCents = freezed,
  }) {
    return _then(_$DailyBalanceImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      openingBalanceCents: null == openingBalanceCents
          ? _value.openingBalanceCents
          : openingBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceCents: null == closingBalanceCents
          ? _value.closingBalanceCents
          : closingBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      projectedCreditsCents: null == projectedCreditsCents
          ? _value.projectedCreditsCents
          : projectedCreditsCents // ignore: cast_nullable_to_non_nullable
              as int,
      projectedDebitsCents: null == projectedDebitsCents
          ? _value.projectedDebitsCents
          : projectedDebitsCents // ignore: cast_nullable_to_non_nullable
              as int,
      freeBalanceCents: freezed == freeBalanceCents
          ? _value.freeBalanceCents
          : freeBalanceCents // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$DailyBalanceImpl implements _DailyBalance {
  const _$DailyBalanceImpl(
      {required this.date,
      this.accountId,
      required this.openingBalanceCents,
      required this.closingBalanceCents,
      required this.projectedCreditsCents,
      required this.projectedDebitsCents,
      this.freeBalanceCents});

  @override
  final DateOnly date;
  @override
  final String? accountId;
  @override
  final int openingBalanceCents;
  @override
  final int closingBalanceCents;
  @override
  final int projectedCreditsCents;
  @override
  final int projectedDebitsCents;
  @override
  final int? freeBalanceCents;

  @override
  String toString() {
    return 'DailyBalance(date: $date, accountId: $accountId, openingBalanceCents: $openingBalanceCents, closingBalanceCents: $closingBalanceCents, projectedCreditsCents: $projectedCreditsCents, projectedDebitsCents: $projectedDebitsCents, freeBalanceCents: $freeBalanceCents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyBalanceImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.openingBalanceCents, openingBalanceCents) ||
                other.openingBalanceCents == openingBalanceCents) &&
            (identical(other.closingBalanceCents, closingBalanceCents) ||
                other.closingBalanceCents == closingBalanceCents) &&
            (identical(other.projectedCreditsCents, projectedCreditsCents) ||
                other.projectedCreditsCents == projectedCreditsCents) &&
            (identical(other.projectedDebitsCents, projectedDebitsCents) ||
                other.projectedDebitsCents == projectedDebitsCents) &&
            (identical(other.freeBalanceCents, freeBalanceCents) ||
                other.freeBalanceCents == freeBalanceCents));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      accountId,
      openingBalanceCents,
      closingBalanceCents,
      projectedCreditsCents,
      projectedDebitsCents,
      freeBalanceCents);

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      __$$DailyBalanceImplCopyWithImpl<_$DailyBalanceImpl>(this, _$identity);
}

abstract class _DailyBalance implements DailyBalance {
  const factory _DailyBalance(
      {required final DateOnly date,
      final String? accountId,
      required final int openingBalanceCents,
      required final int closingBalanceCents,
      required final int projectedCreditsCents,
      required final int projectedDebitsCents,
      final int? freeBalanceCents}) = _$DailyBalanceImpl;

  @override
  DateOnly get date;
  @override
  String? get accountId;
  @override
  int get openingBalanceCents;
  @override
  int get closingBalanceCents;
  @override
  int get projectedCreditsCents;
  @override
  int get projectedDebitsCents;
  @override
  int? get freeBalanceCents;

  /// Create a copy of DailyBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyBalanceImplCopyWith<_$DailyBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
