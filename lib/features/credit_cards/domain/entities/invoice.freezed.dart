// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  String get creditCardId => throw _privateConstructorUsedError;
  String get referenceMonth => throw _privateConstructorUsedError;
  DateOnly get closingDate => throw _privateConstructorUsedError;
  DateOnly get dueDate => throw _privateConstructorUsedError;
  InvoiceStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {String id,
      String creditCardId,
      String referenceMonth,
      DateOnly closingDate,
      DateOnly dueDate,
      InvoiceStatus status,
      DateTime createdAt});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creditCardId = null,
    Object? referenceMonth = null,
    Object? closingDate = null,
    Object? dueDate = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardId: null == creditCardId
          ? _value.creditCardId
          : creditCardId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceMonth: null == referenceMonth
          ? _value.referenceMonth
          : referenceMonth // ignore: cast_nullable_to_non_nullable
              as String,
      closingDate: null == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String creditCardId,
      String referenceMonth,
      DateOnly closingDate,
      DateOnly dueDate,
      InvoiceStatus status,
      DateTime createdAt});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creditCardId = null,
    Object? referenceMonth = null,
    Object? closingDate = null,
    Object? dueDate = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creditCardId: null == creditCardId
          ? _value.creditCardId
          : creditCardId // ignore: cast_nullable_to_non_nullable
              as String,
      referenceMonth: null == referenceMonth
          ? _value.referenceMonth
          : referenceMonth // ignore: cast_nullable_to_non_nullable
              as String,
      closingDate: null == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl(
      {required this.id,
      required this.creditCardId,
      required this.referenceMonth,
      required this.closingDate,
      required this.dueDate,
      required this.status,
      required this.createdAt});

  @override
  final String id;
  @override
  final String creditCardId;
  @override
  final String referenceMonth;
  @override
  final DateOnly closingDate;
  @override
  final DateOnly dueDate;
  @override
  final InvoiceStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Invoice(id: $id, creditCardId: $creditCardId, referenceMonth: $referenceMonth, closingDate: $closingDate, dueDate: $dueDate, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creditCardId, creditCardId) ||
                other.creditCardId == creditCardId) &&
            (identical(other.referenceMonth, referenceMonth) ||
                other.referenceMonth == referenceMonth) &&
            (identical(other.closingDate, closingDate) ||
                other.closingDate == closingDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, creditCardId, referenceMonth,
      closingDate, dueDate, status, createdAt);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);
}

abstract class _Invoice implements Invoice {
  const factory _Invoice(
      {required final String id,
      required final String creditCardId,
      required final String referenceMonth,
      required final DateOnly closingDate,
      required final DateOnly dueDate,
      required final InvoiceStatus status,
      required final DateTime createdAt}) = _$InvoiceImpl;

  @override
  String get id;
  @override
  String get creditCardId;
  @override
  String get referenceMonth;
  @override
  DateOnly get closingDate;
  @override
  DateOnly get dueDate;
  @override
  InvoiceStatus get status;
  @override
  DateTime get createdAt;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
