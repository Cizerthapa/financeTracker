import 'package:finance_track/screens/watch_screens/expense_entry.dart';
import 'package:finance_track/screens/watch_screens/spending_alerts.dart';
import 'package:finance_track/screens/watch_screens/watchwearos_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddtransactionOrSpendingalerts extends StatefulWidget {
  const AddtransactionOrSpendingalerts({super.key});

  @override
  State<AddtransactionOrSpendingalerts> createState() => _AddtransactionOrSpendingalertsState();
}

class _AddtransactionOrSpendingalertsState extends State<AddtransactionOrSpendingalerts> {

  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;

    if (dx < -10)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WatchwearosHomescreen()));
    }

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEntry(cateogries: "",)));


                      },
                      child: Text(
                        "Add New Transaction",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SpendingAlerts()));

                      },
                      child: Text(
                        "Spending Alerts",
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
