// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvoiceItem {
  String get id => throw _privateConstructorUsedError;
  String get invoiceId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  DateOnly get purchaseDate => throw _privateConstructorUsedError;
  int get installmentNumber => throw _privateConstructorUsedError;
  int get installmentTotal => throw _privateConstructorUsedError;
  String get purchaseGroupId =>
      throw _privateConstructorUsedError; // Preenchido só em itens vindos de importação de fatura OFX/CSV
// (M7, #025) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  String? get externalId =>
      throw _privateConstructorUsedError; // Pra onde foi o gasto, não como foi pago (M7, #029). Itens de
// importação (OFX/CSV) ficam em 'outros' — não dá pra inferir
// categoria de um extrato de fatura automaticamente.
  TransactionCategory get category => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceItemCopyWith<InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemCopyWith<$Res> {
  factory $InvoiceItemCopyWith(
          InvoiceItem value, $Res Function(InvoiceItem) then) =
      _$InvoiceItemCopyWithImpl<$Res, InvoiceItem>;
  @useResult
  $Res call(
      {String id,
      String invoiceId,
      String description,
      int amountCents,
      DateOnly purchaseDate,
      int installmentNumber,
      int installmentTotal,
      String purchaseGroupId,
      String? externalId,
      TransactionCategory category,
      DateTime createdAt});
}

/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res, $Val extends InvoiceItem>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? description = null,
    Object? amountCents = null,
    Object? purchaseDate = null,
    Object? installmentNumber = null,
    Object? installmentTotal = null,
    Object? purchaseGroupId = null,
    Object? externalId = freezed,
    Object? category = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      installmentNumber: null == installmentNumber
          ? _value.installmentNumber
          : installmentNumber // ignore: cast_nullable_to_non_nullable
              as int,
      installmentTotal: null == installmentTotal
          ? _value.installmentTotal
          : installmentTotal // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseGroupId: null == purchaseGroupId
          ? _value.purchaseGroupId
          : purchaseGroupId // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$InvoiceItemImplCopyWith(
          _$InvoiceItemImpl value, $Res Function(_$InvoiceItemImpl) then) =
      __$$InvoiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String invoiceId,
      String description,
      int amountCents,
      DateOnly purchaseDate,
      int installmentNumber,
      int installmentTotal,
      String purchaseGroupId,
      String? externalId,
      TransactionCategory category,
      DateTime createdAt});
}

/// @nodoc
class __$$InvoiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$InvoiceItemImpl>
    implements _$$InvoiceItemImplCopyWith<$Res> {
  __$$InvoiceItemImplCopyWithImpl(
      _$InvoiceItemImpl _value, $Res Function(_$InvoiceItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? description = null,
    Object? amountCents = null,
    Object? purchaseDate = null,
    Object? installmentNumber = null,
    Object? installmentTotal = null,
    Object? purchaseGroupId = null,
    Object? externalId = freezed,
    Object? category = null,
    Object? createdAt = null,
  }) {
    return _then(_$InvoiceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountCents: null == amountCents
          ? _value.amountCents
          : amountCents // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      installmentNumber: null == installmentNumber
          ? _value.installmentNumber
          : installmentNumber // ignore: cast_nullable_to_non_nullable
              as int,
      installmentTotal: null == installmentTotal
          ? _value.installmentTotal
          : installmentTotal // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseGroupId: null == purchaseGroupId
          ? _value.purchaseGroupId
          : purchaseGroupId // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

class _$InvoiceItemImpl implements _InvoiceItem {
  const _$InvoiceItemImpl(
      {required this.id,
      required this.invoiceId,
      required this.description,
      required this.amountCents,
      required this.purchaseDate,
      required this.installmentNumber,
      required this.installmentTotal,
      required this.purchaseGroupId,
      this.externalId,
      this.category = TransactionCategory.outros,
      required this.createdAt});

  @override
  final String id;
  @override
  final String invoiceId;
  @override
  final String description;
  @override
  final int amountCents;
  @override
  final DateOnly purchaseDate;
  @override
  final int installmentNumber;
  @override
  final int installmentTotal;
  @override
  final String purchaseGroupId;
// Preenchido só em itens vindos de importação de fatura OFX/CSV
// (M7, #025) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  @override
  final String? externalId;
// Pra onde foi o gasto, não como foi pago (M7, #029). Itens de
// importação (OFX/CSV) ficam em 'outros' — não dá pra inferir
// categoria de um extrato de fatura automaticamente.
  @override
  @JsonKey()
  final TransactionCategory category;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'InvoiceItem(id: $id, invoiceId: $invoiceId, description: $description, amountCents: $amountCents, purchaseDate: $purchaseDate, installmentNumber: $installmentNumber, installmentTotal: $installmentTotal, purchaseGroupId: $purchaseGroupId, externalId: $externalId, category: $category, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.installmentNumber, installmentNumber) ||
                other.installmentNumber == installmentNumber) &&
            (identical(other.installmentTotal, installmentTotal) ||
                other.installmentTotal == installmentTotal) &&
            (identical(other.purchaseGroupId, purchaseGroupId) ||
                other.purchaseGroupId == purchaseGroupId) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      invoiceId,
      description,
      amountCents,
      purchaseDate,
      installmentNumber,
      installmentTotal,
      purchaseGroupId,
      externalId,
      category,
      createdAt);

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      __$$InvoiceItemImplCopyWithImpl<_$InvoiceItemImpl>(this, _$identity);
}

abstract class _InvoiceItem implements InvoiceItem {
  const factory _InvoiceItem(
      {required final String id,
      required final String invoiceId,
      required final String description,
      required final int amountCents,
      required final DateOnly purchaseDate,
      required final int installmentNumber,
      required final int installmentTotal,
      required final String purchaseGroupId,
      final String? externalId,
      final TransactionCategory category,
      required final DateTime createdAt}) = _$InvoiceItemImpl;

  @override
  String get id;
  @override
  String get invoiceId;
  @override
  String get description;
  @override
  int get amountCents;
  @override
  DateOnly get purchaseDate;
  @override
  int get installmentNumber;
  @override
  int get installmentTotal;
  @override
  String
      get purchaseGroupId; // Preenchido só em itens vindos de importação de fatura OFX/CSV
// (M7, #025) — usado pra deduplicar reimportação do mesmo período.
// `null` em todo o resto do app.
  @override
  String?
      get externalId; // Pra onde foi o gasto, não como foi pago (M7, #029). Itens de
// importação (OFX/CSV) ficam em 'outros' — não dá pra inferir
// categoria de um extrato de fatura automaticamente.
  @override
  TransactionCategory get category;
  @override
  DateTime get createdAt;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
