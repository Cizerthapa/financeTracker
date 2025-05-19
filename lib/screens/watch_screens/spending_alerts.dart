<<<<<<< HEAD
=======
import 'package:flutter/cupertino.dart';
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
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

<<<<<<< HEAD
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    if (details.delta.dx < -10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddtransactionOrSpendingalerts()),
      );
=======
  void handleSwipe(BuildContext context, DragUpdateDetails details)
  {

    double dx = details.delta.dx;
    if (dx > 10) {
      Navigator.of(context).pop();
    } else if (dx < -10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddNewBudget()),
      );
    }
    else if(dx < -10)
    {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewBudget()));
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
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
<<<<<<< HEAD
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

      Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);
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
=======
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Column(
                children: [
                  Text(
                    'Spending Alerts',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rent',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          '\$50',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '-',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '\$100',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
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
<<<<<<< HEAD
                ),
              ],
=======
                ],
              ),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
            ),
          ),
        ),
      ),
    );
  }
}
