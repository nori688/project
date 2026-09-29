import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _onNotificationTap(NotificationResponse response) async {
    dev.log("уведомление открыто: ${response.payload}");
    print('уведомление получено!');
  }

  Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifies =
        AndroidNotificationDetails('instant_channel', 'Мгновенные уведомления',
            channelDescription: 'Канал для мгновенных уведомлений',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_launcer');

    const NotificationDetails platformChannelSpecifies =
        NotificationDetails(android: androidPlatformChannelSpecifies);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Мгновенные уведомления',
      'Описание уведомления',
      platformChannelSpecifies,
      payload: 'instant',
    );
  }

  Future<void> scheduleNotification(DateTime scheduledDateTime) async {
    try {
      if (scheduledDateTime.isBefore(DateTime.now())) {
        dev.log(
            'уведомление запланировано на завтра в ${scheduledDateTime.hour}:${scheduledDateTime.minute}');
        scheduledDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
          21,
          45,
          0,
        );
      } else {
        dev.log(
            'Уведомление запланировано на ${scheduledDateTime.hour}:${scheduledDateTime.minute}');
        print('проверка');
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifies =
          AndroidNotificationDetails(
        'instant_channel',
        'Мгновенные уведомления',
        channelDescription: 'Канал для мгновенных уведомлений',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifies =
          NotificationDetails(android: androidPlatformChannelSpecifies);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Предупреждение о комендантском часе',
        'Проживающий! Через 15 минут общежитие закрывается, успей вернуться до 22:00.',
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        platformChannelSpecifies,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'instant',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      dev.log('поймана ошибка: $e');
    }
  }

  Future<void> saveNotifications(
      List<Map<String, String>> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi list ke JSON string
    String jsonString = jsonEncode(notifications);
    await prefs.setString('notifications', jsonString);
  }

  Future<List<Map<String, String>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('notifications');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }
}
