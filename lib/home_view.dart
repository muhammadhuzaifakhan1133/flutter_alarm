import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:timezone/timezone.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}


class _HomeViewState extends State<HomeView> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize the flutter_local_notifications plugin
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () async {
          var scheduledNotificationDateTime =
              DateTime.now().add(const Duration(seconds: 10));
          var androidPlatformChannelSpecifics =
              const AndroidNotificationDetails('your channel id',
                  'your channel name', 'your channel description',
                  importance: Importance.max,
                  ongoing: true,
                  priority: Priority.high,
                  ticker: 'ticker');
          var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.zonedSchedule(
              0,
              'scheduled title',
              'scheduled body',
              TZDateTime.from(
                  scheduledNotificationDateTime, getLocation('Asia/Karachi')),
              platformChannelSpecifics,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);

          await FlutterRingtonePlayer.play(
            android: AndroidSounds.alarm,
            ios: IosSounds.alarm,
            looping: true,
            volume: 1.0,
          );
        },
        child: const Text('Show Alarm Notification with Ring'),
      ),
    );
  }
}
