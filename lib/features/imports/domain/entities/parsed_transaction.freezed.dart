// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParsedTransaction {
  DateOnly get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  String get externalId => throw _privateConstructorUsedError;

  /// Create a copy of ParsedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParsedTransactionCopyWith<ParsedTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParsedTransactionCopyWith<$Res> {
  factory $ParsedTransactionCopyWith(
          ParsedTransaction value, $Res Function(ParsedTransaction) then) =
      _$ParsedTransactionCopyWithImpl<$Res, ParsedTransaction>;
  @useResult
  $Res call(
      {DateOnly date, String description, int amountCents, String externalId});
}

/// @nodoc
class _$ParsedTransactionCopyWithImpl<$Res, $Val extends ParsedTransaction>
    implements $ParsedTransactionCopyWith<$Res> {
  _$ParsedTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParsedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? description = null,
    Object? amountCents = null,
    Object? externalId = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      externalId: null == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParsedTransactionImplCopyWith<$Res>
    implements $ParsedTransactionCopyWith<$Res> {
  factory _$$ParsedTransactionImplCopyWith(_$ParsedTransactionImpl value,
          $Res Function(_$ParsedTransactionImpl) then) =
      __$$ParsedTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateOnly date, String description, int amountCents, String externalId});
}

/// @nodoc
class __$$ParsedTransactionImplCopyWithImpl<$Res>
    extends _$ParsedTransactionCopyWithImpl<$Res, _$ParsedTransactionImpl>
    implements _$$ParsedTransactionImplCopyWith<$Res> {
  __$$ParsedTransactionImplCopyWithImpl(_$ParsedTransactionImpl _value,
      $Res Function(_$ParsedTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParsedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? description = null,
    Object? amountCents = null,
    Object? externalId = null,
  }) {
    return _then(_$ParsedTransactionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      externalId: null == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ParsedTransactionImpl implements _ParsedTransaction {
  const _$ParsedTransactionImpl(
      {required this.date,
      required this.description,
      required this.amountCents,
      required this.externalId});

  @override
  final DateOnly date;
  @override
  final String description;
  @override
  final int amountCents;
  @override
  final String externalId;

  @override
  String toString() {
    return 'ParsedTransaction(date: $date, description: $description, amountCents: $amountCents, externalId: $externalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsedTransactionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, description, amountCents, externalId);

  /// Create a copy of ParsedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsedTransactionImplCopyWith<_$ParsedTransactionImpl> get copyWith =>
      __$$ParsedTransactionImplCopyWithImpl<_$ParsedTransactionImpl>(
          this, _$identity);
}

abstract class _ParsedTransaction implements ParsedTransaction {
  const factory _ParsedTransaction(
      {required final DateOnly date,
      required final String description,
      required final int amountCents,
      required final String externalId}) = _$ParsedTransactionImpl;

  @override
  DateOnly get date;
  @override
  String get description;
  @override
  int get amountCents;
  @override
  String get externalId;

  /// Create a copy of ParsedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParsedTransactionImplCopyWith<_$ParsedTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
