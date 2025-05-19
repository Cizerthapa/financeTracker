import 'package:finance_track/screens/watch_screens/expense_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/MessageProvider.dart';
import '../../providers/login_provider.dart';
import '../../providers/notification_provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  final List<String> category = [
    'Rent',
    'Loan',
    'Food',
    'Transportation',
    'Groceries',
    'Utilities',
    'Entertainment',
    'Healthcare',
    'Education',
    'Savings',
    'Shopping',
    'Other',
  ];
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
    // TODO: implement initState
    super.initState();
    watchConnectivity = WatchConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);

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
    return Scaffold(
      body: Container(
        color: Color(0xFF1D85B1),
        child: Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Container(
          child: ListView.builder(
              itemCount: category.length,
              itemBuilder: (BuildContext context, int index) {
            return Container(

        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEntry(cateogries: category[index])));
            },
            child: Container(

              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(category[index]),
              ),
            ),
          ),
        ),

            );}
            ),
        ),),
      ),
    );
  }
}
