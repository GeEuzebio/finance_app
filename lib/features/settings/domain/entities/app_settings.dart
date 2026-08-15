import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(30) int projectionHorizonDays,
    @Default(20) int savingsTargetPercent,
    @Default(false) bool checkInReminderEnabled,
    // Minutos desde meia-noite — evita lidar com serialização de
    // TimeOfDay; 1200 = 20:00.
    @Default(1200) int checkInReminderMinutes,
  }) = _AppSettings;
}
