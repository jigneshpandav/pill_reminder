import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications({BuildContext? context}) async {
  var initializeAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializeIOS = const IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
  await localNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) {
    if (payload != null) {
       Provider.of<HomeProvider>(context!,listen: false).showNotification1(payload.toString());
    }
  });
}

Future singleNotification(DateTime scheduledDate, String title, String body,
    int hashCode, DateTime data,
    {String? sound}) async {
  var androidChannel = const AndroidNotificationDetails(
    'channel-id', 'channel-name',
    // importance: Importance.Max,
    // priority: Priority.Max,
  );
  final timeZone = TimeZone();
  var iosChannel = const IOSNotificationDetails();
  var platformChannel =
      NotificationDetails(android: androidChannel, iOS: iosChannel);

  String timeZoneName = await timeZone.getTimeZoneName();

  // Find the 'current location'
  final location = await timeZone.getLocation(timeZoneName);
  DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 1);

  final scheduledDate1 = tz.TZDateTime(
      location,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute + 1);
  print("Data:-$scheduledDate1");
  try {
    print("IN");
    await localNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      scheduledDate1,
      platformChannel,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: data.toString(),
    );
    print("OUT");
  } catch (err) {
    print(err);
  }
}

class TimeZone {
  factory TimeZone() => _this ?? TimeZone._();

  TimeZone._() {
    initializeTimeZones();
  }

  static TimeZone? _this;

  Future<String> getTimeZoneName() async =>
      FlutterNativeTimezone.getLocalTimezone();

  Future<tz.Location> getLocation([String? timeZoneName]) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }
    return tz.getLocation(timeZoneName);
  }
}
