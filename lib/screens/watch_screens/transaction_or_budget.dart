import 'package:finance_track/screens/watch_screens/budget_summary.dart';
import 'package:finance_track/screens/watch_screens/transaction_history.dart';
import 'package:finance_track/screens/watch_screens/watchwearos_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/notification_message_provider.dart';
import '../../providers/notification_provider.dart';

class TransactionOrBudget extends StatefulWidget {
  const TransactionOrBudget({super.key});

  @override
  State<TransactionOrBudget> createState() => _TransactionOrBudgetState();
}

class _TransactionOrBudgetState extends State<TransactionOrBudget> {
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;

    if (dx > 10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WatchwearosHomescreen()));
    }

  }


  late WatchConnectivity watchConnectivity;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void showNotification(String name) async {

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
          try {
            if (message.containsKey("notification")) {

              showNotification(message["notification"]);
              Provider.of<MessageProvider>(context, listen: false)
                  .addMessage(message["notification"]);
              print("Received message 'notification' key: $message");
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


    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          width: double.infinity,
          height: double.infinity,

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3343),
                        /*    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),*/
                      ),
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory()));

                      },
                      child: Text(
                        "Transaction Summary"
                            "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3343),
                        /*    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),*/
                      ),
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetSummary()));

                      },
                      child: Text(
                        "Budget Summary",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10
                        ),
                      )),
                ),

              ],
            ),
          ),
        ),
      ),

    ));
  }
}
