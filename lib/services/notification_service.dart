// AgriVision NTB - Enhanced Notification Service
// Service untuk notifikasi treatment calendar dengan fitur canggih

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/treatment_schedule.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  
  static const String _channelTreatment = 'treatment_reminders';
  static const String _channelUrgent = 'urgent_reminders';
  static const String _channelGeneral = 'general';
  static const String _channelDisease = 'disease_detection';
  static const String _channelWeather = 'weather_alerts';

  /// Check if notifications are enabled
  bool get isNotificationsEnabled => _notificationsEnabled;

  /// Set notification enabled state
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    if (!enabled) {
      cancelAllNotifications();
    }
  }

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Makassar')); // WITA for NTB

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('NotificationService: Initialized successfully');
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      'NotificationService: Notification tapped - ${response.payload}',
    );
    // Handle notification tap - navigate to treatment detail
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Get Android notification details based on priority
  AndroidNotificationDetails _getAndroidDetails(
    SchedulePriority priority, {
    String? channelId,
  }) {
    switch (priority) {
      case SchedulePriority.urgent:
        return const AndroidNotificationDetails(
          _channelUrgent,
          'Pengingat Mendesak',
          channelDescription: 'Notifikasi mendesak untuk perawatan segera',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          color: Color(0xFFE53935),
          colorized: true,
          category: AndroidNotificationCategory.alarm,
        );
      case SchedulePriority.high:
        return const AndroidNotificationDetails(
          _channelTreatment,
          'Pengingat Perawatan',
          channelDescription: 'Notifikasi pengingat jadwal perawatan tanaman',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          color: Color(0xFFFF9800),
          colorized: true,
        );
      case SchedulePriority.medium:
        return AndroidNotificationDetails(
          channelId ?? _channelTreatment,
          'Pengingat Perawatan',
          channelDescription: 'Notifikasi pengingat jadwal perawatan tanaman',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          color: const Color(0xFF2196F3),
          colorized: true,
        );
      case SchedulePriority.low:
        return const AndroidNotificationDetails(
          _channelGeneral,
          'Notifikasi Umum',
          channelDescription: 'Notifikasi umum dari AgriVision NTB',
          importance: Importance.low,
          priority: Priority.low,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF4CAF50),
          colorized: true,
        );
    }
  }

  /// Schedule treatment reminder with advanced features
  Future<void> scheduleTreatmentReminder(TreatmentSchedule schedule) async {
    if (!_notificationsEnabled) {
      debugPrint(
        'NotificationService: Notifications disabled, skipping schedule',
      );
      return;
    }
    if (!schedule.isNotificationEnabled) {
      debugPrint(
        'NotificationService: Schedule notification disabled, skipping',
      );
      return;
    }

    final exactScheduledTime = schedule.scheduledDate;

    debugPrint('NotificationService: Scheduling "${schedule.treatmentName}"');
    debugPrint(
      'NotificationService: Time: $exactScheduledTime | Priority: ${schedule.priorityText}',
    );

    // If scheduled time is in the past, show immediate notification
    if (exactScheduledTime.isBefore(DateTime.now())) {
      debugPrint(
        'NotificationService: Time is in the past, showing immediate notification',
      );
      await showTreatmentNotification(schedule);
      return;
    }

    // If time is very close (within 1 minute), show notification now
    if (exactScheduledTime.difference(DateTime.now()).inMinutes < 1) {
      debugPrint(
        'NotificationService: Time is very close, showing notification now',
      );
      await showTreatmentNotification(schedule);
      return;
    }

    final androidDetails = _getAndroidDetails(schedule.priority);

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Main notification at exact time
      String title = _getTitleForPriority(schedule);
      String body = '${schedule.typeEmoji} ${schedule.treatmentName}';
      if (schedule.dosage.isNotEmpty) {
        body += ' - ${schedule.dosage}';
      }
      if (schedule.recurrence != RecurrenceType.none) {
        body += ' (${schedule.recurrenceText})';
      }

      await _notifications.zonedSchedule(
        schedule.id.hashCode,
        title,
        body,
        tz.TZDateTime.from(exactScheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: schedule.id,
      );
      debugPrint(
        'NotificationService: Main notification scheduled for $exactScheduledTime',
      );

      // Schedule reminder X minutes before if set
      if (schedule.reminderMinutesBefore > 0) {
        final minutesBefore = exactScheduledTime.subtract(
          Duration(minutes: schedule.reminderMinutesBefore),
        );

        if (minutesBefore.isAfter(DateTime.now())) {
          await _notifications.zonedSchedule(
            (schedule.id + '_minutes').hashCode,
            '⏰ ${schedule.reminderMinutesBefore} menit lagi!',
            '${schedule.typeEmoji} ${schedule.treatmentName} akan dimulai',
            tz.TZDateTime.from(minutesBefore, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: schedule.id,
          );
          debugPrint(
            'NotificationService: Minutes reminder scheduled for $minutesBefore',
          );
        }
      }

      // Schedule reminder X days before if set
      if (schedule.reminderDaysBefore > 0) {
        final reminderTime = exactScheduledTime.subtract(
          Duration(days: schedule.reminderDaysBefore),
        );

        if (reminderTime.isAfter(DateTime.now())) {
          await _notifications.zonedSchedule(
            (schedule.id + '_days').hashCode,
            '📅 Pengingat: ${schedule.treatmentName}',
            'Jadwal perawatan dalam ${schedule.reminderDaysBefore} hari lagi',
            tz.TZDateTime.from(reminderTime, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: schedule.id,
          );
          debugPrint(
            'NotificationService: Days reminder scheduled for $reminderTime',
          );
        }
      }
    } catch (e) {
      debugPrint('NotificationService: Error scheduling notification: $e');
    }
  }

  /// Get title based on priority
  String _getTitleForPriority(TreatmentSchedule schedule) {
    switch (schedule.priority) {
      case SchedulePriority.urgent:
        return '🚨 MENDESAK: Perawatan Sekarang!';
      case SchedulePriority.high:
        return '⚠️ Penting: Waktunya Perawatan!';
      case SchedulePriority.medium:
        return '🌱 Waktunya Perawatan Tanaman';
      case SchedulePriority.low:
        return '💡 Pengingat Perawatan';
    }
  }

  /// Show immediate treatment notification
  Future<void> showTreatmentNotification(TreatmentSchedule schedule) async {
    if (!_notificationsEnabled) return;

    final androidDetails = _getAndroidDetails(schedule.priority);

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title = _getTitleForPriority(schedule);
    String body = '${schedule.typeEmoji} ${schedule.treatmentName}';
    if (schedule.dosage.isNotEmpty) {
      body += ' - ${schedule.dosage}';
    }

    await _notifications.show(
      schedule.id.hashCode,
      title,
      body,
      details,
      payload: schedule.id,
    );

    debugPrint(
      'NotificationService: Immediate notification shown for ${schedule.treatmentName}',
    );
  }

  /// Show overdue notification
  Future<void> showOverdueNotification(TreatmentSchedule schedule) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      _channelUrgent,
      'Pengingat Mendesak',
      channelDescription: 'Notifikasi untuk jadwal yang terlewat',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      color: Color(0xFFE53935),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      (schedule.id + '_overdue').hashCode,
      '⏰ Jadwal Terlewat!',
      '${schedule.typeEmoji} ${schedule.treatmentName} sudah melewati waktu yang dijadwalkan',
      details,
      payload: schedule.id,
    );
  }

  /// Show weather warning notification
  Future<void> showWeatherWarningNotification({
    required String treatmentName,
    required String weatherCondition,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      _channelWeather,
      'Peringatan Cuaca',
      channelDescription: 'Notifikasi peringatan cuaca untuk perawatan',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      color: Color(0xFF2196F3),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      '🌧️ Peringatan Cuaca',
      'Jadwal "$treatmentName" mungkin perlu ditunda karena $weatherCondition',
      details,
    );
  }

  /// Test notification - for debugging
  Future<void> showTestNotification() async {
    debugPrint('NotificationService: Showing test notification');

    const androidDetails = AndroidNotificationDetails(
      _channelTreatment,
      'Pengingat Perawatan',
      channelDescription: 'Notifikasi pengingat jadwal perawatan tanaman',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      color: Color(0xFF4CAF50),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      '🧪 Test Notifikasi AgriVision',
      'Notifikasi berfungsi dengan baik! Selamat berkebun! 🌱',
      details,
    );

    debugPrint('NotificationService: Test notification sent');
  }

  /// Cancel treatment reminder
  Future<void> cancelTreatmentReminder(String scheduleId) async {
    await _notifications.cancel(scheduleId.hashCode);
    await _notifications.cancel((scheduleId + '_minutes').hashCode);
    await _notifications.cancel((scheduleId + '_days').hashCode);
    await _notifications.cancel((scheduleId + '_overdue').hashCode);
    debugPrint(
      'NotificationService: Cancelled all notifications for $scheduleId',
    );
  }

  /// Show immediate notification (for sync completion, etc.)
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    SchedulePriority priority = SchedulePriority.medium,
  }) async {
    if (!_notificationsEnabled) return;

    final androidDetails = _getAndroidDetails(priority);
    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Show disease detection notification
  Future<void> showDiseaseDetectedNotification({
    required String diseaseName,
    required String severity,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      _channelDisease,
      'Deteksi Penyakit',
      channelDescription: 'Notifikasi hasil deteksi penyakit tanaman',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      color: Color(0xFFE53935),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      '⚠️ Penyakit Terdeteksi!',
      '$diseaseName - Keparahan: $severity',
      details,
    );
  }

  /// Show success notification
  Future<void> showSuccessNotification({
    required String title,
    required String body,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      _channelGeneral,
      'Notifikasi Umum',
      channelDescription: 'Notifikasi umum dari AgriVision NTB',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4CAF50),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      '✅ $title',
      body,
      details,
    );
  }

  /// Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    final pending = await _notifications.pendingNotificationRequests();
    return pending.length;
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('NotificationService: All notifications cancelled');
  }
}
