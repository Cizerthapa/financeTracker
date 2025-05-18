import 'package:finance_track/screens/watch_screens/budget_summary.dart';
import 'package:finance_track/screens/watch_screens/transaction_history.dart';
import 'package:finance_track/screens/watch_screens/watchwearos_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
