
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_new_budget.dart';

class SpendingAlerts extends StatefulWidget {
  const SpendingAlerts({super.key});

  @override
  State<SpendingAlerts> createState() => _SpendingAlertsState();
}

class _SpendingAlertsState extends State<SpendingAlerts> {
  void handleSwipe(BuildContext context, DragUpdateDetails details)
  {
    double dx = details.delta.dx;
    if (dx > 10)
    {
      Navigator.of(context).pop();
    }
    else if(dx < -10)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewBudget()));
      }
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
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Column(
                children: [

                  Text("Spending Alerts",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 3,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                    
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Rent", style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11
                                    ),),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text("\$50", style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 11
                                        ),),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text("-", style: TextStyle(
                                            color: Colors.red
                                            ,fontSize: 11
                                        ),),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text("\$100", style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11
                                        ),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

            ),
          ),

        ),
      ),
    );
  }
}
