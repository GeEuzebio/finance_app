// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreditCard {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get paymentAccountId => throw _privateConstructorUsedError;
  int get closingDay => throw _privateConstructorUsedError;
  int get dueDay => throw _privateConstructorUsedError;
  int? get limitCents => throw _privateConstructorUsedError;
  AccountOwner get owner => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditCardCopyWith<CreditCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditCardCopyWith<$Res> {
  factory $CreditCardCopyWith(
          CreditCard value, $Res Function(CreditCard) then) =
      _$CreditCardCopyWithImpl<$Res, CreditCard>;
  @useResult
  $Res call(
      {String id,
      String name,
      String paymentAccountId,
      int closingDay,
      int dueDay,
      int? limitCents,
      AccountOwner owner,
      DateTime createdAt});
}

/// @nodoc
class _$CreditCardCopyWithImpl<$Res, $Val extends CreditCard>
    implements $CreditCardCopyWith<$Res> {
  _$CreditCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? paymentAccountId = null,
    Object? closingDay = null,
    Object? dueDay = null,
    Object? limitCents = freezed,
    Object? owner = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAccountId: null == paymentAccountId
          ? _value.paymentAccountId
          : paymentAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      closingDay: null == closingDay
          ? _value.closingDay
          : closingDay // ignore: cast_nullable_to_non_nullable
              as int,
      dueDay: null == dueDay
          ? _value.dueDay
          : dueDay // ignore: cast_nullable_to_non_nullable
              as int,
      limitCents: freezed == limitCents
          ? _value.limitCents
          : limitCents // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as AccountOwner,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreditCardImplCopyWith<$Res>
    implements $CreditCardCopyWith<$Res> {
  factory _$$CreditCardImplCopyWith(
          _$CreditCardImpl value, $Res Function(_$CreditCardImpl) then) =
      __$$CreditCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String paymentAccountId,
      int closingDay,
      int dueDay,
      int? limitCents,
      AccountOwner owner,
      DateTime createdAt});
}

/// @nodoc
class __$$CreditCardImplCopyWithImpl<$Res>
    extends _$CreditCardCopyWithImpl<$Res, _$CreditCardImpl>
    implements _$$CreditCardImplCopyWith<$Res> {
  __$$CreditCardImplCopyWithImpl(
      _$CreditCardImpl _value, $Res Function(_$CreditCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? paymentAccountId = null,
    Object? closingDay = null,
    Object? dueDay = null,
    Object? limitCents = freezed,
    Object? owner = null,
    Object? createdAt = null,
  }) {
    return _then(_$CreditCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAccountId: null == paymentAccountId
          ? _value.paymentAccountId
          : paymentAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      closingDay: null == closingDay
          ? _value.closingDay
          : closingDay // ignore: cast_nullable_to_non_nullable
              as int,
      dueDay: null == dueDay
          ? _value.dueDay
          : dueDay // ignore: cast_nullable_to_non_nullable
              as int,
      limitCents: freezed == limitCents
          ? _value.limitCents
          : limitCents // ignore: cast_nullable_to_non_nullable
              as int?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as AccountOwner,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CreditCardImpl implements _CreditCard {
  const _$CreditCardImpl(
      {required this.id,
      required this.name,
      required this.paymentAccountId,
      required this.closingDay,
      required this.dueDay,
      this.limitCents,
      required this.owner,
      required this.createdAt});

  @override
  final String id;
  @override
  final String name;
  @override
  final String paymentAccountId;
  @override
  final int closingDay;
  @override
  final int dueDay;
  @override
  final int? limitCents;
  @override
  final AccountOwner owner;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CreditCard(id: $id, name: $name, paymentAccountId: $paymentAccountId, closingDay: $closingDay, dueDay: $dueDay, limitCents: $limitCents, owner: $owner, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.paymentAccountId, paymentAccountId) ||
                other.paymentAccountId == paymentAccountId) &&
            (identical(other.closingDay, closingDay) ||
                other.closingDay == closingDay) &&
            (identical(other.dueDay, dueDay) || other.dueDay == dueDay) &&
            (identical(other.limitCents, limitCents) ||
                other.limitCents == limitCents) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, paymentAccountId,
      closingDay, dueDay, limitCents, owner, createdAt);

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      __$$CreditCardImplCopyWithImpl<_$CreditCardImpl>(this, _$identity);
}

abstract class _CreditCard implements CreditCard {
  const factory _CreditCard(
      {required final String id,
      required final String name,
      required final String paymentAccountId,
      required final int closingDay,
      required final int dueDay,
      final int? limitCents,
      required final AccountOwner owner,
      required final DateTime createdAt}) = _$CreditCardImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get paymentAccountId;
  @override
  int get closingDay;
  @override
  int get dueDay;
  @override
  int? get limitCents;
  @override
  AccountOwner get owner;
  @override
  DateTime get createdAt;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
