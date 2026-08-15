import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Lembrete diário local de check-in (M7, #022) — sem servidor, sem push
/// remoto, uma única notificação recorrente reagendada pra "amanhã no
/// mesmo horário" via `matchDateTimeComponents`.
@lazySingleton
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'checkin_reminder';
  static const _channelName = 'Lembrete de check-in';
  static const _notificationId = 1;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    // requestAlertPermission/requestBadgePermission/requestSoundPermission
    // são `true` por padrão no plugin — deixaria o iOS pedir permissão
    // sozinho aqui, no boot do app. A permissão só deve ser pedida quando
    // o usuário liga o lembrete em Configurações (`requestPermission`).
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: 'Lembrete diário pra fazer o check-in do dia',
          ),
        );
  }

  Future<bool> requestPermission() async {
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final android = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return (ios ?? true) && (android ?? true);
  }

  Future<void> scheduleDailyReminder({required int hour, required int minute}) {
    return _plugin.zonedSchedule(
      id: _notificationId,
      title: 'Check-in do dia',
      body: 'Confirme, ajuste ou adie o que estava previsto pra hoje.',
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
        iOS: DarwinNotificationDetails(),
      ),
      // ponytail: inexactAllowWhileIdle evita exigir a permissão especial
      // de alarme exato (SCHEDULE_EXACT_ALARM) — um lembrete "por volta
      // desse horário" não precisa de precisão ao minuto.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() => _plugin.cancel(id: _notificationId);

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
