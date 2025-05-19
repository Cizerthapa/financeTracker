import 'package:finance_track/providers/transaction_provider.dart';
import 'package:finance_track/screens/watch_screens/transaction_or_budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/MessageProvider.dart';
import '../../providers/login_provider.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late WatchConnectivity watchConnectivity;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    watchConnectivity = WatchConnectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

      loginProvider.wearOsLogout(watchConnectivity, context);
      transactionProvider.fetchTransactionsFromFirebase();

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
            Provider.of<MessageProvider>(context, listen: false)
                .addMessage(notification);
            print("Received notification: $notification");
          } else {
            print("Message without 'notification' key: $message");
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
      showWhen: false,
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransactionOrBudget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final groupedTx = provider.groupedTransactions;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          color: const Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Column(
            children: [
              const Text(
                "Transaction Summary",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: groupedTx.entries
                          .expand((entry) => entry.value)
                          .map((item) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const Spacer(),

                                Row(
                                  children: [
                                    Icon(
                                      item.type != 'Income'
                                          ? Icons.arrow_drop_down_sharp
                                          : Icons.arrow_drop_up_sharp,
                                      color: item.type != 'Income'
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    Text(
                                      'Rs.${item.amount.abs().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: item.type != 'Income'
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
