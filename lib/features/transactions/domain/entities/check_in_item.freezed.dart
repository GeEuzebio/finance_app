// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckInItem {
  String? get transactionId => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  DateOnly get date => throw _privateConstructorUsedError;
  TransactionCategory get category => throw _privateConstructorUsedError;
  String? get recurrenceRuleId =>
      throw _privateConstructorUsedError; // null pra item ainda virtual — materializar usa DateTime.now() nesse
// caso; preservado ao reeditar um item já materializado, pra não
// corromper o createdAt original da Transaction real.
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CheckInItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckInItemCopyWith<CheckInItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInItemCopyWith<$Res> {
  factory $CheckInItemCopyWith(
          CheckInItem value, $Res Function(CheckInItem) then) =
      _$CheckInItemCopyWithImpl<$Res, CheckInItem>;
  @useResult
  $Res call(
      {String? transactionId,
      String accountId,
      String accountName,
      String description,
      int amountCents,
      DateOnly date,
      TransactionCategory category,
      String? recurrenceRuleId,
      DateTime? createdAt});
}

/// @nodoc
class _$CheckInItemCopyWithImpl<$Res, $Val extends CheckInItem>
    implements $CheckInItemCopyWith<$Res> {
  _$CheckInItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckInItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = freezed,
    Object? accountId = null,
    Object? accountName = null,
    Object? description = null,
    Object? amountCents = null,
    Object? date = null,
    Object? category = null,
    Object? recurrenceRuleId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      recurrenceRuleId: freezed == recurrenceRuleId
          ? _value.recurrenceRuleId
          : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckInItemImplCopyWith<$Res>
    implements $CheckInItemCopyWith<$Res> {
  factory _$$CheckInItemImplCopyWith(
          _$CheckInItemImpl value, $Res Function(_$CheckInItemImpl) then) =
      __$$CheckInItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? transactionId,
      String accountId,
      String accountName,
      String description,
      int amountCents,
      DateOnly date,
      TransactionCategory category,
      String? recurrenceRuleId,
      DateTime? createdAt});
}

/// @nodoc
class __$$CheckInItemImplCopyWithImpl<$Res>
    extends _$CheckInItemCopyWithImpl<$Res, _$CheckInItemImpl>
    implements _$$CheckInItemImplCopyWith<$Res> {
  __$$CheckInItemImplCopyWithImpl(
      _$CheckInItemImpl _value, $Res Function(_$CheckInItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckInItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = freezed,
    Object? accountId = null,
    Object? accountName = null,
    Object? description = null,
    Object? amountCents = null,
    Object? date = null,
    Object? category = null,
    Object? recurrenceRuleId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$CheckInItemImpl(
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      recurrenceRuleId: freezed == recurrenceRuleId
          ? _value.recurrenceRuleId
          : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CheckInItemImpl extends _CheckInItem {
  const _$CheckInItemImpl(
      {this.transactionId,
      required this.accountId,
      required this.accountName,
      required this.description,
      required this.amountCents,
      required this.date,
      this.category = TransactionCategory.outros,
      this.recurrenceRuleId,
      this.createdAt})
      : super._();

  @override
  final String? transactionId;
  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String description;
  @override
  final int amountCents;
  @override
  final DateOnly date;
  @override
  @JsonKey()
  final TransactionCategory category;
  @override
  final String? recurrenceRuleId;
// null pra item ainda virtual — materializar usa DateTime.now() nesse
// caso; preservado ao reeditar um item já materializado, pra não
// corromper o createdAt original da Transaction real.
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CheckInItem(transactionId: $transactionId, accountId: $accountId, accountName: $accountName, description: $description, amountCents: $amountCents, date: $date, category: $category, recurrenceRuleId: $recurrenceRuleId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInItemImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.recurrenceRuleId, recurrenceRuleId) ||
                other.recurrenceRuleId == recurrenceRuleId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionId,
      accountId,
      accountName,
      description,
      amountCents,
      date,
      category,
      recurrenceRuleId,
      createdAt);

  /// Create a copy of CheckInItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInItemImplCopyWith<_$CheckInItemImpl> get copyWith =>
      __$$CheckInItemImplCopyWithImpl<_$CheckInItemImpl>(this, _$identity);
}

abstract class _CheckInItem extends CheckInItem {
  const factory _CheckInItem(
      {final String? transactionId,
      required final String accountId,
      required final String accountName,
      required final String description,
      required final int amountCents,
      required final DateOnly date,
      final TransactionCategory category,
      final String? recurrenceRuleId,
      final DateTime? createdAt}) = _$CheckInItemImpl;
  const _CheckInItem._() : super._();

  @override
  String? get transactionId;
  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get description;
  @override
  int get amountCents;
  @override
  DateOnly get date;
  @override
  TransactionCategory get category;
  @override
  String?
      get recurrenceRuleId; // null pra item ainda virtual — materializar usa DateTime.now() nesse
// caso; preservado ao reeditar um item já materializado, pra não
// corromper o createdAt original da Transaction real.
  @override
  DateTime? get createdAt;

  /// Create a copy of CheckInItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckInItemImplCopyWith<_$CheckInItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
