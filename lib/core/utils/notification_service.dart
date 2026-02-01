import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // Use var and toString() to handle potential type mismatch (String vs TimezoneInfo)
    // appearing in some environments
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
    } catch (e) {
      // Fallback if timezone not found
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    final fln.DarwinInitializationSettings initializationSettingsDarwin =
        fln.DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final fln.InitializationSettings initializationSettings =
        fln.InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (fln.NotificationResponse response) async {
            // Handle notification tap
          },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            fln.AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            fln.IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'daily_checklist_channel',
          'Daily Checklist Reminders',
          channelDescription: 'Reminders for daily oral care checklist',
          importance: fln.Importance.max,
          priority: fln.Priority.high,
        ),
        iOS: fln.DarwinNotificationDetails(),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: fln.DateTimeComponents.time,
    );
  }

  Future<void> scheduleTestAlarm() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(seconds: 10));

    // Log for debugging
    print('DEBUG: Scheduling test alarm');
    print('DEBUG: Current time: $now');
    print('DEBUG: Scheduled for: $scheduledDate');
    print('DEBUG: Local timezone: ${tz.local}');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      999,
      'Test Alarm (10 Detik)',
      'Alarm ini muncul 10 detik setelah dijadwalkan. Waktu: ${scheduledDate.toString()}',
      scheduledDate,
      const fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'daily_checklist_channel',
          'Daily Checklist Reminders',
          channelDescription: 'Reminders for daily oral care checklist',
          importance: fln.Importance.max,
          priority: fln.Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: fln.DarwinNotificationDetails(),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );

    final pending = await getPendingNotifications();
    print('DEBUG: Pending notifications after scheduling: ${pending.length}');
    for (var p in pending) {
      print('DEBUG: Pending ID=${p.id}, title=${p.title}');
    }
  }

  String getDebugInfo() {
    final now = tz.TZDateTime.now(tz.local);
    return 'TZ Local: ${tz.local.name}\nNow: $now';
  }

  Future<List<fln.PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> scheduleAllReminders() async {
    // Cancel all previous to avoid duplicates
    await cancelAllNotifications();

    // Morning Care (07:00) -> Remind at 06:45
    await scheduleDailyNotification(
      id: 1,
      title: 'Selamat Pagi, Keluarga Hebat! ☀️',
      body:
          'Waktunya bersiap untuk perawatan mulut pagi. Sentuhan kasih Anda sangat berarti bagi kenyamanan pasien.',
      hour: 6,
      minute: 45,
    );

    // Afternoon Care (12:00) -> Remind at 11:45
    await scheduleDailyNotification(
      id: 2,
      title: 'Siap untuk Perawatan Siang? 🌤️',
      body:
          'Setelah makan siang nanti, jangan lupa bersihkan mulut pasien ya. Kebersihan adalah kunci kesehatan.',
      hour: 11,
      minute: 45,
    );

    // Night Care (19:00) -> Remind at 18:45
    await scheduleDailyNotification(
      id: 3,
      title: 'Menuju Istirahat Malam 🌙',
      body:
          'Mari bersiap untuk perawatan mulut sebelum tidur. Mulut yang bersih membantu pasien tidur lebih nyenyak.',
      hour: 18,
      minute: 45,
    );

    // Cancel Danger Signs Check (id: 4) if it exists
    await cancelNotification(4);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
