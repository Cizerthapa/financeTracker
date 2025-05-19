<<<<<<< HEAD

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track/screens/watch_screens/addtransaction_or_spendingalerts.dart';
=======
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/MessageProvider.dart';
import '../../providers/login_provider.dart';

import '../../providers/notification_provider.dart';
import '../../providers/transaction_provider.dart';
import 'categories.dart';

class ExpenseEntry extends StatefulWidget {
  final String cateogries;

  const ExpenseEntry({super.key, required this.cateogries});

  @override
  State<ExpenseEntry> createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
<<<<<<< HEAD



  void handleSwipe(BuildContext context, DragUpdateDetails details)
  {
    double dx = details.delta.dx;
    if (dx < -10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionOrSpendingalerts()));
=======
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    if (dx < -10) {
      Navigator.of(context).pop();
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
    }
  }

  bool isIncome = false;
  bool isExpenses = true;

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

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _closeKeyboard() {

    _focusNode.unfocus();
  }

  bool _isSaving = false;

  Future<void> _saveTransaction() async {

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');

    if (uid == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d, y').format(now);

    print(double.parse(_controller.text));
    print(widget.cateogries);
    print(isIncome ? "Income" : "Expenses");
    print(formattedDate);
    print(uid);
    print(Timestamp.now());

    final newTx = {
      'amount': double.parse(_controller.text),
      'title': widget.cateogries,
      'method': "Cash",
      'type': isIncome ? "Income" : "Expense",
      'date': formattedDate,
      'uid': uid,
      'timestamp': Timestamp.now(),
    };

    try {
      await Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTx);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved!')),
      );



      Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionOrSpendingalerts()));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save transaction.')),
      );
    }

    setState(() => _isSaving = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          color: Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 18),
              child: Center(
                child: Column(
                  children: [
                    Text("Add New Transaction",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
<<<<<<< HEAD
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
=======
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
<<<<<<< HEAD
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Categories()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 👈 Important to avoid overflow
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tag_rounded, size: 16, color: Colors.black87),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.cateogries.isEmpty ? "Title" : widget.cateogries,
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                              overflow: TextOverflow.ellipsis, // 👈 Prevents long text overflow
=======
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Categories()),
                        );
                      },
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Adjust size based on content
                        children: [
                          Icon(
                            Icons.tag_rounded,
                            size: 16,
                            color: Colors.black87,
                          ),

                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                            ),
                          ),
                        ],
                      ),
                    ),
<<<<<<< HEAD

                    SizedBox(height: 2,),
=======
                    SizedBox(height: 2),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                    Center(
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                            setState(() {
                              isIncome = true;
                              isExpenses = false;
                            });
                            },
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Adjust size based on content
                              children: [
<<<<<<< HEAD
                                Icon(isIncome ? Icons.check_box : Icons.check_box_outline_blank, size: 14, color: Colors.black87),
=======
                                Icon(
                                  Icons.check_box_outline_blank,
                                  size: 14,
                                  color: Colors.black87,
                                ),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                                SizedBox(width: 4),
                                Text(
                                  'Income',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                             setState(() {
                               isIncome = false;
                               isExpenses = true;
                             });
                            },
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Adjust size based on content
                              children: [
<<<<<<< HEAD
                                Icon(isExpenses ? Icons.check_box : Icons.check_box_outline_blank, size: 14, color: Colors.black87),
=======
                                Icon(
                                  Icons.check_box_outline_blank,
                                  size: 14,
                                  color: Colors.black87,
                                ),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                                SizedBox(width: 4),
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      child: Row(
                        children: [
<<<<<<< HEAD
                          // Number TextField
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Enter number',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          // X Button
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _closeKeyboard,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
=======
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Set background color here
                              borderRadius: BorderRadius.circular(
                                5,
                              ), // Set the border radius here
                            ),
                            child: SizedBox(
                              width: 155,
                              height: 35,

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attach_money_outlined,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 1),
                                  Text('0'),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 3),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Calculator(),
                                ),
                              );
                            },
                            child: Icon(Icons.calculate_sharp, size: 28),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: ()
                      {


                        _saveTransaction();

                      },
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Adjust size based on content
                        children: [
                          Text(
                            'Done',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
