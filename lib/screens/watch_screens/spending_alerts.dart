import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/notification_message_provider.dart';
import '../../providers/login_provider.dart';
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

  @override
  void initState() {
    super.initState();
    watchConnectivity = WatchConnectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false)
          .wearOsLogout(watchConnectivity, context);

      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      try {
        watchConnectivity.messageStream.listen((message) {
          if (message.containsKey("notification")) {
            final notification = message["notification"];
            showNotification(notification);

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

  void showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'basic_channel',
      'Basic Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Notification",
      message,
      notificationDetails,
    );
  }

  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    final dx = details.delta.dx;

    if (dx > 10) {
      Navigator.of(context).pop();
    } else if (dx < -10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddtransactionOrSpendingalerts()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<MessageProvider>().messages;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          color: const Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                "Spending Alerts",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: messages.isEmpty
                    ? const Center(
                  child: Text(
                    "No notifications yet",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications,
                                color: Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                messages[index],
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
    );
  }
}
