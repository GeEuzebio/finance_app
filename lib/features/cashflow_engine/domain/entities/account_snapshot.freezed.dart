// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountSnapshot {
  String get id => throw _privateConstructorUsedError;
  int get initialBalanceCents => throw _privateConstructorUsedError;
  DateOnly get initialBalanceDate => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;

  /// Create a copy of AccountSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountSnapshotCopyWith<AccountSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountSnapshotCopyWith<$Res> {
  factory $AccountSnapshotCopyWith(
          AccountSnapshot value, $Res Function(AccountSnapshot) then) =
      _$AccountSnapshotCopyWithImpl<$Res, AccountSnapshot>;
  @useResult
  $Res call(
      {String id,
      int initialBalanceCents,
      DateOnly initialBalanceDate,
      bool archived});
}

/// @nodoc
class _$AccountSnapshotCopyWithImpl<$Res, $Val extends AccountSnapshot>
    implements $AccountSnapshotCopyWith<$Res> {
  _$AccountSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? initialBalanceCents = null,
    Object? initialBalanceDate = null,
    Object? archived = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalanceCents: null == initialBalanceCents
          ? _value.initialBalanceCents
          : initialBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      initialBalanceDate: null == initialBalanceDate
          ? _value.initialBalanceDate
          : initialBalanceDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      archived: null == archived
          ? _value.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountSnapshotImplCopyWith<$Res>
    implements $AccountSnapshotCopyWith<$Res> {
  factory _$$AccountSnapshotImplCopyWith(_$AccountSnapshotImpl value,
          $Res Function(_$AccountSnapshotImpl) then) =
      __$$AccountSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int initialBalanceCents,
      DateOnly initialBalanceDate,
      bool archived});
}

/// @nodoc
class __$$AccountSnapshotImplCopyWithImpl<$Res>
    extends _$AccountSnapshotCopyWithImpl<$Res, _$AccountSnapshotImpl>
    implements _$$AccountSnapshotImplCopyWith<$Res> {
  __$$AccountSnapshotImplCopyWithImpl(
      _$AccountSnapshotImpl _value, $Res Function(_$AccountSnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? initialBalanceCents = null,
    Object? initialBalanceDate = null,
    Object? archived = null,
  }) {
    return _then(_$AccountSnapshotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalanceCents: null == initialBalanceCents
          ? _value.initialBalanceCents
          : initialBalanceCents // ignore: cast_nullable_to_non_nullable
              as int,
      initialBalanceDate: null == initialBalanceDate
          ? _value.initialBalanceDate
          : initialBalanceDate // ignore: cast_nullable_to_non_nullable
              as DateOnly,
      archived: null == archived
          ? _value.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AccountSnapshotImpl implements _AccountSnapshot {
  const _$AccountSnapshotImpl(
      {required this.id,
      required this.initialBalanceCents,
      required this.initialBalanceDate,
      required this.archived});

  @override
  final String id;
  @override
  final int initialBalanceCents;
  @override
  final DateOnly initialBalanceDate;
  @override
  final bool archived;

  @override
  String toString() {
    return 'AccountSnapshot(id: $id, initialBalanceCents: $initialBalanceCents, initialBalanceDate: $initialBalanceDate, archived: $archived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountSnapshotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.initialBalanceCents, initialBalanceCents) ||
                other.initialBalanceCents == initialBalanceCents) &&
            (identical(other.initialBalanceDate, initialBalanceDate) ||
                other.initialBalanceDate == initialBalanceDate) &&
            (identical(other.archived, archived) ||
                other.archived == archived));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, initialBalanceCents, initialBalanceDate, archived);

  /// Create a copy of AccountSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountSnapshotImplCopyWith<_$AccountSnapshotImpl> get copyWith =>
      __$$AccountSnapshotImplCopyWithImpl<_$AccountSnapshotImpl>(
          this, _$identity);
}

abstract class _AccountSnapshot implements AccountSnapshot {
  const factory _AccountSnapshot(
      {required final String id,
      required final int initialBalanceCents,
      required final DateOnly initialBalanceDate,
      required final bool archived}) = _$AccountSnapshotImpl;

  @override
  String get id;
  @override
  int get initialBalanceCents;
  @override
  DateOnly get initialBalanceDate;
  @override
  bool get archived;

  /// Create a copy of AccountSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountSnapshotImplCopyWith<_$AccountSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
