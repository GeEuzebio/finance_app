// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  AccountType get type => throw _privateConstructorUsedError;
  AccountOwner get owner => throw _privateConstructorUsedError;
  int get initialBalanceCents => throw _privateConstructorUsedError;
  DateOnly get initialBalanceDate => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String id,
      String name,
      AccountType type,
      AccountOwner owner,
      int initialBalanceCents,
      DateOnly initialBalanceDate,
      bool archived,
      DateTime createdAt});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? owner = null,
    Object? initialBalanceCents = null,
    Object? initialBalanceDate = null,
    Object? archived = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as AccountOwner,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      AccountType type,
      AccountOwner owner,
      int initialBalanceCents,
      DateOnly initialBalanceDate,
      bool archived,
      DateTime createdAt});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? owner = null,
    Object? initialBalanceCents = null,
    Object? initialBalanceDate = null,
    Object? archived = null,
    Object? createdAt = null,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as AccountOwner,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$AccountImpl implements _Account {
  const _$AccountImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.owner,
      required this.initialBalanceCents,
      required this.initialBalanceDate,
      required this.archived,
      required this.createdAt});

  @override
  final String id;
  @override
  final String name;
  @override
  final AccountType type;
  @override
  final AccountOwner owner;
  @override
  final int initialBalanceCents;
  @override
  final DateOnly initialBalanceDate;
  @override
  final bool archived;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Account(id: $id, name: $name, type: $type, owner: $owner, initialBalanceCents: $initialBalanceCents, initialBalanceDate: $initialBalanceDate, archived: $archived, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.initialBalanceCents, initialBalanceCents) ||
                other.initialBalanceCents == initialBalanceCents) &&
            (identical(other.initialBalanceDate, initialBalanceDate) ||
                other.initialBalanceDate == initialBalanceDate) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, owner,
      initialBalanceCents, initialBalanceDate, archived, createdAt);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {required final String id,
      required final String name,
      required final AccountType type,
      required final AccountOwner owner,
      required final int initialBalanceCents,
      required final DateOnly initialBalanceDate,
      required final bool archived,
      required final DateTime createdAt}) = _$AccountImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  AccountType get type;
  @override
  AccountOwner get owner;
  @override
  int get initialBalanceCents;
  @override
  DateOnly get initialBalanceDate;
  @override
  bool get archived;
  @override
  DateTime get createdAt;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
