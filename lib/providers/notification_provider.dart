import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider with ChangeNotifier {

  late final WatchConnectivity _watchConnectivity;
  String _notification = "";

  String get notification => _notification;
  WatchConnectivity get watchConnectivity => _watchConnectivity;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    try {
      _watchConnectivity = WatchConnectivity();

      // Initialize notification plugin
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      flutterLocalNotificationsPlugin
          .initialize(initializationSettings)
          .then((_) {
        print("FlutterLocalNotificationsPlugin initialized successfully.");
      }).catchError((error, stackTrace) {
        print("Error initializing FlutterLocalNotificationsPlugin: $error");
        print(stackTrace);
      });

      _startListening();
    } catch (e, stackTrace) {
      print("Error in NotificationProvider constructor: $e");
      print(stackTrace);
    }
  }

  void _startListening() {
    try {
      _watchConnectivity.messageStream.listen((message) {
        try {
          if (message.containsKey("notification")) {
            _notification = message["notification"];
            print("Received from watch: $_notification");

            showNotification(_notification);
            notifyListeners();
          } else {
            print("Received message without 'notification' key: $message");
          }
        } catch (e, stackTrace) {
          print("Error processing incoming message: $e");
          print(stackTrace);
        }
      }, onError: (error, stackTrace) {
        print("Error in messageStream listener: $error");
        print(stackTrace);
      });
    } catch (e, stackTrace) {
      print("Error setting up messageStream listener: $e");
      print(stackTrace);
    }
  }

  Future<void> showNotification(String message) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'basic_channel',
        'Basic Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        "Notification",
        message,
        platformChannelSpecifics,
      );

      print("Notification shown successfully: $message");
    } catch (e, stackTrace) {
      print("Error showing notification: $e");
      print(stackTrace);
    }
  }
}
