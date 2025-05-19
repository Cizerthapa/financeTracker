import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/login_provider.dart';
import '../../providers/notification_provider.dart';


class BudgetSummary extends StatefulWidget {
  const BudgetSummary({super.key});

  @override
  State<BudgetSummary> createState() => _BudgetSummaryState();
}

class _BudgetSummaryState extends State<BudgetSummary> {
  void handleSwipe(BuildContext context, DragUpdateDetails details)
  {
    double dx = details.delta.dx;
    if (dx > 10)
    {
      Navigator.of(context).pop();
    }
  }
  late WatchConnectivity watchConnectivity;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    watchConnectivity = WatchConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);

      final notification = Provider.of<NotificationProvider>(context, listen: false).notification;

      setState(() {
        print("Notification: $notification");
      });

    });

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
            child: Padding(
              padding: EdgeInsets.only(left: 20, right:20, top: 10),
              child: Column(
                children: [
                  Text(
                    "Budget Summary",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Food", style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                  Spacer(),
                                  Text("0%", style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ],
                              ),

                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                height: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: 0.5,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                              ),

                            ],
                          );
                        },
                  ),

                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
