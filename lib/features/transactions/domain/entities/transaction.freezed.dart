// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  DateOnly get date => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  String? get recurrenceRuleId => throw _privateConstructorUsedError;
  String? get originalTransactionId => throw _privateConstructorUsedError;
  String? get transferGroupId => throw _privateConstructorUsedError;
  String? get invoicePaymentForId =>
      throw _privateConstructorUsedError; // Preenchido só em lançamentos vindos de importação OFX/CSV
// (M7, #023) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  String? get externalId =>
      throw _privateConstructorUsedError; // Pra onde foi o gasto, não como foi pago (M7, #029).
  TransactionCategory get category => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String description,
      int amountCents,
      DateOnly date,
      TransactionStatus status,
      String? recurrenceRuleId,
      String? originalTransactionId,
      String? transferGroupId,
      String? invoicePaymentForId,
      String? externalId,
      TransactionCategory category,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? description = null,
    Object? amountCents = null,
    Object? date = null,
    Object? status = null,
    Object? recurrenceRuleId = freezed,
    Object? originalTransactionId = freezed,
    Object? transferGroupId = freezed,
    Object? invoicePaymentForId = freezed,
    Object? externalId = freezed,
    Object? category = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      recurrenceRuleId: freezed == recurrenceRuleId
          ? _value.recurrenceRuleId
          : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalTransactionId: freezed == originalTransactionId
          ? _value.originalTransactionId
          : originalTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      transferGroupId: freezed == transferGroupId
          ? _value.transferGroupId
          : transferGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoicePaymentForId: freezed == invoicePaymentForId
          ? _value.invoicePaymentForId
          : invoicePaymentForId // ignore: cast_nullable_to_non_nullable
              as String?,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String description,
      int amountCents,
      DateOnly date,
      TransactionStatus status,
      String? recurrenceRuleId,
      String? originalTransactionId,
      String? transferGroupId,
      String? invoicePaymentForId,
      String? externalId,
      TransactionCategory category,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? description = null,
    Object? amountCents = null,
    Object? date = null,
    Object? status = null,
    Object? recurrenceRuleId = freezed,
    Object? originalTransactionId = freezed,
    Object? transferGroupId = freezed,
    Object? invoicePaymentForId = freezed,
    Object? externalId = freezed,
    Object? category = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      recurrenceRuleId: freezed == recurrenceRuleId
          ? _value.recurrenceRuleId
          : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalTransactionId: freezed == originalTransactionId
          ? _value.originalTransactionId
          : originalTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      transferGroupId: freezed == transferGroupId
          ? _value.transferGroupId
          : transferGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoicePaymentForId: freezed == invoicePaymentForId
          ? _value.invoicePaymentForId
          : invoicePaymentForId // ignore: cast_nullable_to_non_nullable
              as String?,
      externalId: freezed == externalId
          ? _value.externalId
          : externalId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TransactionCategory,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.id,
      required this.accountId,
      required this.description,
      required this.amountCents,
      required this.date,
      required this.status,
      this.recurrenceRuleId,
      this.originalTransactionId,
      this.transferGroupId,
      this.invoicePaymentForId,
      this.externalId,
      this.category = TransactionCategory.outros,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String description;
  @override
  final int amountCents;
  @override
  final DateOnly date;
  @override
  final TransactionStatus status;
  @override
  final String? recurrenceRuleId;
  @override
  final String? originalTransactionId;
  @override
  final String? transferGroupId;
  @override
  final String? invoicePaymentForId;
// Preenchido só em lançamentos vindos de importação OFX/CSV
// (M7, #023) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  @override
  final String? externalId;
// Pra onde foi o gasto, não como foi pago (M7, #029).
  @override
  @JsonKey()
  final TransactionCategory category;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Transaction(id: $id, accountId: $accountId, description: $description, amountCents: $amountCents, date: $date, status: $status, recurrenceRuleId: $recurrenceRuleId, originalTransactionId: $originalTransactionId, transferGroupId: $transferGroupId, invoicePaymentForId: $invoicePaymentForId, externalId: $externalId, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recurrenceRuleId, recurrenceRuleId) ||
                other.recurrenceRuleId == recurrenceRuleId) &&
            (identical(other.originalTransactionId, originalTransactionId) ||
                other.originalTransactionId == originalTransactionId) &&
            (identical(other.transferGroupId, transferGroupId) ||
                other.transferGroupId == transferGroupId) &&
            (identical(other.invoicePaymentForId, invoicePaymentForId) ||
                other.invoicePaymentForId == invoicePaymentForId) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      description,
      amountCents,
      date,
      status,
      recurrenceRuleId,
      originalTransactionId,
      transferGroupId,
      invoicePaymentForId,
      externalId,
      category,
      createdAt,
      updatedAt);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {required final String id,
      required final String accountId,
      required final String description,
      required final int amountCents,
      required final DateOnly date,
      required final TransactionStatus status,
      final String? recurrenceRuleId,
      final String? originalTransactionId,
      final String? transferGroupId,
      final String? invoicePaymentForId,
      final String? externalId,
      final TransactionCategory category,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TransactionImpl;

  @override
  String get id;
  @override
  String get accountId;
  @override
  String get description;
  @override
  int get amountCents;
  @override
  DateOnly get date;
  @override
  TransactionStatus get status;
  @override
  String? get recurrenceRuleId;
  @override
  String? get originalTransactionId;
  @override
  String? get transferGroupId;
  @override
  String?
      get invoicePaymentForId; // Preenchido só em lançamentos vindos de importação OFX/CSV
// (M7, #023) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  @override
  String? get externalId; // Pra onde foi o gasto, não como foi pago (M7, #029).
  @override
  TransactionCategory get category;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
