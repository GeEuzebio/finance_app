// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppSettings {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  int get projectionHorizonDays => throw _privateConstructorUsedError;
  int get savingsTargetPercent => throw _privateConstructorUsedError;
  bool get checkInReminderEnabled =>
      throw _privateConstructorUsedError; // Minutos desde meia-noite — evita lidar com serialização de
// TimeOfDay; 1200 = 20:00.
  int get checkInReminderMinutes => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      int projectionHorizonDays,
      int savingsTargetPercent,
      bool checkInReminderEnabled,
      int checkInReminderMinutes});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? projectionHorizonDays = null,
    Object? savingsTargetPercent = null,
    Object? checkInReminderEnabled = null,
    Object? checkInReminderMinutes = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      projectionHorizonDays: null == projectionHorizonDays
          ? _value.projectionHorizonDays
          : projectionHorizonDays // ignore: cast_nullable_to_non_nullable
              as int,
      savingsTargetPercent: null == savingsTargetPercent
          ? _value.savingsTargetPercent
          : savingsTargetPercent // ignore: cast_nullable_to_non_nullable
              as int,
      checkInReminderEnabled: null == checkInReminderEnabled
          ? _value.checkInReminderEnabled
          : checkInReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInReminderMinutes: null == checkInReminderMinutes
          ? _value.checkInReminderMinutes
          : checkInReminderMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      int projectionHorizonDays,
      int savingsTargetPercent,
      bool checkInReminderEnabled,
      int checkInReminderMinutes});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? projectionHorizonDays = null,
    Object? savingsTargetPercent = null,
    Object? checkInReminderEnabled = null,
    Object? checkInReminderMinutes = null,
  }) {
    return _then(_$AppSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      projectionHorizonDays: null == projectionHorizonDays
          ? _value.projectionHorizonDays
          : projectionHorizonDays // ignore: cast_nullable_to_non_nullable
              as int,
      savingsTargetPercent: null == savingsTargetPercent
          ? _value.savingsTargetPercent
          : savingsTargetPercent // ignore: cast_nullable_to_non_nullable
              as int,
      checkInReminderEnabled: null == checkInReminderEnabled
          ? _value.checkInReminderEnabled
          : checkInReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInReminderMinutes: null == checkInReminderMinutes
          ? _value.checkInReminderMinutes
          : checkInReminderMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.themeMode = ThemeMode.system,
      this.projectionHorizonDays = 30,
      this.savingsTargetPercent = 20,
      this.checkInReminderEnabled = false,
      this.checkInReminderMinutes = 1200});

  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final int projectionHorizonDays;
  @override
  @JsonKey()
  final int savingsTargetPercent;
  @override
  @JsonKey()
  final bool checkInReminderEnabled;
// Minutos desde meia-noite — evita lidar com serialização de
// TimeOfDay; 1200 = 20:00.
  @override
  @JsonKey()
  final int checkInReminderMinutes;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, projectionHorizonDays: $projectionHorizonDays, savingsTargetPercent: $savingsTargetPercent, checkInReminderEnabled: $checkInReminderEnabled, checkInReminderMinutes: $checkInReminderMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.projectionHorizonDays, projectionHorizonDays) ||
                other.projectionHorizonDays == projectionHorizonDays) &&
            (identical(other.savingsTargetPercent, savingsTargetPercent) ||
                other.savingsTargetPercent == savingsTargetPercent) &&
            (identical(other.checkInReminderEnabled, checkInReminderEnabled) ||
                other.checkInReminderEnabled == checkInReminderEnabled) &&
            (identical(other.checkInReminderMinutes, checkInReminderMinutes) ||
                other.checkInReminderMinutes == checkInReminderMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeMode, projectionHorizonDays,
      savingsTargetPercent, checkInReminderEnabled, checkInReminderMinutes);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final ThemeMode themeMode,
      final int projectionHorizonDays,
      final int savingsTargetPercent,
      final bool checkInReminderEnabled,
      final int checkInReminderMinutes}) = _$AppSettingsImpl;

  @override
  ThemeMode get themeMode;
  @override
  int get projectionHorizonDays;
  @override
  int get savingsTargetPercent;
  @override
  bool
      get checkInReminderEnabled; // Minutos desde meia-noite — evita lidar com serialização de
// TimeOfDay; 1200 = 20:00.
  @override
  int get checkInReminderMinutes;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
