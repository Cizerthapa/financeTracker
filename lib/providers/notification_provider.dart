import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationProvider with ChangeNotifier{
  late final WatchConnectivity _watchConnectivity;

  var _notification = "";

  get notification => _notification;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    _watchConnectivity = WatchConnectivity();


    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _startListening();
  }
  void _startListening() {
    _watchConnectivity.messageStream.listen((message) {


      _notification = message["notification"];
      showNotification(_notification);

      notifyListeners();
    });
  }


  void showNotification(String message) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'basic_channel',
      'Basic Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);



    await flutterLocalNotificationsPlugin.show(
      0,
     "Notification",
      message,
      platformChannelSpecifics,
    );
  }

}

