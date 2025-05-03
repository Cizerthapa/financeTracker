import 'package:flutter/material.dart';


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
  @override
  void initState()
  {
    super.initState();

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
                    "Dec, 2025",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
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
