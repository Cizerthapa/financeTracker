import 'package:finance_track/providers/notification_provider.dart';
import 'package:finance_track/screens/watch_screens/addtransaction_or_spendingalerts.dart';
import 'package:finance_track/screens/watch_screens/spending_alerts.dart';
import 'package:finance_track/screens/watch_screens/transaction_history.dart';
import 'package:finance_track/screens/watch_screens/transaction_or_budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import '../../providers/notification_message_provider.dart';
import '../../providers/login_provider.dart';
import '../../providers/transaction_provider.dart';
import 'authorize.dart';
import 'budget_summary.dart';
import 'expense_entry.dart';

class WatchwearosHomescreen extends StatefulWidget {
  const WatchwearosHomescreen({super.key});

  @override
  State<WatchwearosHomescreen> createState() => _WatchwearosHomescreenState();
}

class _WatchwearosHomescreenState extends State<WatchwearosHomescreen> {
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;

    if (dx > 10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionOrSpendingalerts()));
    }
    else if (dx < -10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionOrBudget()));
    }
    // else if (dy > 10)
    // {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory()));
    // }
    // else if (dy < -10)
    // {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => SpendingAlerts()));
    // }
  }

  late WatchConnectivity watchConnectivity;
  bool _isLoading = true;
  bool _isInitialized = false;

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

    watchConnectivity = WatchConnectivity();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        Provider.of<TransactionProvider>(
          context,
          listen: false,
        ).fetchTransactionsFromFirebase().then((_) {
          setState(() {
            _isLoading = false;
            _isInitialized = true;
          });
        });
      }

      // Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);
      //       //
      //       // print("Initial notification: ${notificationProvider.notification}");
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
      backgroundColor: Color(0xFF1D85B1),
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 165,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "₨. ${provider.totalIncome.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Expanded(
                  child: groupedTx.isEmpty
                      ? const Center(child: Text("Nothing to show", style: TextStyle(color: Colors.white, fontSize: 12)))
                      :ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: groupedTx.entries
                        .expand((entry) => entry.value)
                        .take(2)
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
                                    Text(
                                      item.title,
                                      style: TextStyle(fontSize: 10, color: Colors.black),
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
                                          'Rs. ${item.amount.abs().toStringAsFixed(2)}',
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

            Positioned(
              bottom: -15,
              left: 55,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 175,
                  height: 80,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Expenses',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "₨. ${provider.totalExpenses.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Container(
// decoration: BoxDecoration(
// color: Colors.white,
// shape: BoxShape.rectangle,
// borderRadius: BorderRadius.all(Radius.circular(10.0))
// ),
// child: Padding(
// padding: EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 2),
// child: Row(
// children: [
// Text(
// 'Income',
// style: TextStyle(
// fontSize: 10,
// color: Colors.black
// ),
// ),
// Spacer(),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Icon(Icons.arrow_drop_up_sharp, color: Colors.green),
// Text(
// '\$300',
// style: TextStyle(
// fontSize: 10,
// color: Colors.green
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
