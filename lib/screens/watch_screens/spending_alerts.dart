import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/MessageProvider.dart';
import 'addtransaction_or_spendingalerts.dart';

class SpendingAlerts extends StatefulWidget {
  const SpendingAlerts({super.key});

  @override
  State<SpendingAlerts> createState() => _SpendingAlertsState();
}

class _SpendingAlertsState extends State<SpendingAlerts> {
  late WatchConnectivity watchConnectivity;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    if (details.delta.dx < -10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddtransactionOrSpendingalerts()),
      );
    }
  }

  void showNotification(String name) async {
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
      name,
      platformChannelSpecifics,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      watchConnectivity = WatchConnectivity();

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      try {
        watchConnectivity.messageStream.listen((message) {
          if (message.containsKey("notification")) {
            final notification = message["notification"];
            showNotification(notification);

            // Add the message to the provider
            Provider.of<MessageProvider>(context, listen: false)
                .addMessage(notification);

            print("Received notification: $notification");
          } else {
            print("Message received without 'notification' key: $message");
          }
        }, onError: (error, stackTrace) {
          print("Error in messageStream: $error");
          print(stackTrace);
        });
      } catch (e, stackTrace) {
        print("Error setting up listener: $e");
        print(stackTrace);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<MessageProvider>().messages;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          color: Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  "Spending Alerts",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                    child: Text(
                      "No notifications yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.notifications,
                                    color: Colors.black54),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    messages[index],
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
