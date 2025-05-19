import 'package:finance_track/providers/transaction_provider.dart';
import 'package:finance_track/screens/watch_screens/transaction_or_budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/MessageProvider.dart';
import '../../providers/login_provider.dart';
import '../../providers/notification_provider.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  void handleSwipe(BuildContext context, DragUpdateDetails details)
  {
    double dx = details.delta.dx;
    if (dx > 10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionOrBudget()));
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

    watchConnectivity = WatchConnectivity(); // Initialize once

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      loginProvider.wearOsLogout(watchConnectivity, context);
      transactionProvider.fetchTransactionsFromFirebase();
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
    final provider = Provider.of<TransactionProvider>(context);
    final groupedTx = provider.groupedTransactions;
    return Scaffold(

      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
        color: Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            child: Column(
              children: [
                Text(
                  "Transaction Summary",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: groupedTx.entries
                              .expand((entry) => entry.value)
                  
                              .map((item) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            child: Text(
                                              item.title,
                                              style: const TextStyle(fontSize: 10, color: Colors.black),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                item.type != 'Income'
                                                    ? Icons.arrow_drop_down_sharp
                                                    : Icons.arrow_drop_up_sharp,
                                                color: item.type != 'Income' ? Colors.red : Colors.green,
                                              ),
                                              Text(
                                                'Rs.${item.amount.abs().toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: item.type != 'Income' ? Colors.red : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                  
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
        ),
      ),
    );
  }
}
