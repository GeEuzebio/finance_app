import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../notifications/notification_service.dart';
import '../domain/entities/app_settings.dart';

part 'settings_providers.g.dart';

const _keyThemeMode = 'settings.theme_mode';
const _keyProjectionHorizonDays = 'settings.projection_horizon_days';
const _keySavingsTargetPercent = 'settings.savings_target_percent';
const _keyCheckInReminderEnabled = 'settings.checkin_reminder_enabled';
const _keyCheckInReminderMinutes = 'settings.checkin_reminder_minutes';

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) => SharedPreferences.getInstance();

// ponytail: sem repositório/Either aqui — SharedPreferences é o único
// backend possível pra preferência local e não tem modo de falha que o
// app precise tratar; adicionar a abstração se isso mudar um dia.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return AppSettings(
      themeMode: ThemeMode.values.byName(
        prefs.getString(_keyThemeMode) ?? ThemeMode.system.name,
      ),
      projectionHorizonDays: prefs.getInt(_keyProjectionHorizonDays) ?? 30,
      savingsTargetPercent: prefs.getInt(_keySavingsTargetPercent) ?? 20,
      checkInReminderEnabled: prefs.getBool(_keyCheckInReminderEnabled) ?? false,
      checkInReminderMinutes: prefs.getInt(_keyCheckInReminderMinutes) ?? 1200,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_keyThemeMode, mode.name);
    state = AsyncData((state.valueOrNull ?? const AppSettings()).copyWith(themeMode: mode));
  }

  Future<void> setProjectionHorizonDays(int days) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_keyProjectionHorizonDays, days);
    state = AsyncData(
      (state.valueOrNull ?? const AppSettings()).copyWith(projectionHorizonDays: days),
    );
  }

  Future<void> setSavingsTargetPercent(int percent) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_keySavingsTargetPercent, percent);
    state = AsyncData(
      (state.valueOrNull ?? const AppSettings()).copyWith(savingsTargetPercent: percent),
    );
  }

  /// Liga/desliga o lembrete e agenda/cancela a notificação de verdade —
  /// retorna `false` se o usuário negou a permissão (nesse caso nada é
  /// persistido, o toggle na tela deve voltar pro estado anterior).
  Future<bool> setCheckInReminder({required bool enabled, int? minutes}) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final service = getIt<NotificationService>();
    final resolvedMinutes = minutes ?? (state.valueOrNull?.checkInReminderMinutes ?? 1200);

    if (enabled) {
      final granted = await service.requestPermission();
      if (!granted) return false;
      await service.scheduleDailyReminder(
        hour: resolvedMinutes ~/ 60,
        minute: resolvedMinutes % 60,
      );
    } else {
      await service.cancelDailyReminder();
    }

    await prefs.setBool(_keyCheckInReminderEnabled, enabled);
    await prefs.setInt(_keyCheckInReminderMinutes, resolvedMinutes);
    state = AsyncData(
      (state.valueOrNull ?? const AppSettings()).copyWith(
        checkInReminderEnabled: enabled,
        checkInReminderMinutes: resolvedMinutes,
      ),
    );
    return true;
  }
}
