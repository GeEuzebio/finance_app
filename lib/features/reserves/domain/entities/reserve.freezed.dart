// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reserve.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Reserve {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get targetAmountCents => throw _privateConstructorUsedError;
  int get currentAmountCents => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Reserve
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReserveCopyWith<Reserve> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReserveCopyWith<$Res> {
  factory $ReserveCopyWith(Reserve value, $Res Function(Reserve) then) =
      _$ReserveCopyWithImpl<$Res, Reserve>;
  @useResult
  $Res call(
      {String id,
      String name,
      int? targetAmountCents,
      int currentAmountCents,
      DateTime createdAt});
}

/// @nodoc
class _$ReserveCopyWithImpl<$Res, $Val extends Reserve>
    implements $ReserveCopyWith<$Res> {
  _$ReserveCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reserve
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmountCents = freezed,
    Object? currentAmountCents = null,
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
      targetAmountCents: freezed == targetAmountCents
          ? _value.targetAmountCents
          : targetAmountCents // ignore: cast_nullable_to_non_nullable
              as int?,
      currentAmountCents: null == currentAmountCents
          ? _value.currentAmountCents
          : currentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReserveImplCopyWith<$Res> implements $ReserveCopyWith<$Res> {
  factory _$$ReserveImplCopyWith(
          _$ReserveImpl value, $Res Function(_$ReserveImpl) then) =
      __$$ReserveImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int? targetAmountCents,
      int currentAmountCents,
      DateTime createdAt});
}

/// @nodoc
class __$$ReserveImplCopyWithImpl<$Res>
    extends _$ReserveCopyWithImpl<$Res, _$ReserveImpl>
    implements _$$ReserveImplCopyWith<$Res> {
  __$$ReserveImplCopyWithImpl(
      _$ReserveImpl _value, $Res Function(_$ReserveImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reserve
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmountCents = freezed,
    Object? currentAmountCents = null,
    Object? createdAt = null,
  }) {
    return _then(_$ReserveImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmountCents: freezed == targetAmountCents
          ? _value.targetAmountCents
          : targetAmountCents // ignore: cast_nullable_to_non_nullable
              as int?,
      currentAmountCents: null == currentAmountCents
          ? _value.currentAmountCents
          : currentAmountCents // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ReserveImpl implements _Reserve {
  const _$ReserveImpl(
      {required this.id,
      required this.name,
      this.targetAmountCents,
      required this.currentAmountCents,
      required this.createdAt});

  @override
  final String id;
  @override
  final String name;
  @override
  final int? targetAmountCents;
  @override
  final int currentAmountCents;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Reserve(id: $id, name: $name, targetAmountCents: $targetAmountCents, currentAmountCents: $currentAmountCents, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReserveImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmountCents, targetAmountCents) ||
                other.targetAmountCents == targetAmountCents) &&
            (identical(other.currentAmountCents, currentAmountCents) ||
                other.currentAmountCents == currentAmountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, targetAmountCents, currentAmountCents, createdAt);

  /// Create a copy of Reserve
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReserveImplCopyWith<_$ReserveImpl> get copyWith =>
      __$$ReserveImplCopyWithImpl<_$ReserveImpl>(this, _$identity);
}

abstract class _Reserve implements Reserve {
  const factory _Reserve(
      {required final String id,
      required final String name,
      final int? targetAmountCents,
      required final int currentAmountCents,
      required final DateTime createdAt}) = _$ReserveImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  int? get targetAmountCents;
  @override
  int get currentAmountCents;
  @override
  DateTime get createdAt;

  /// Create a copy of Reserve
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReserveImplCopyWith<_$ReserveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
