import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calculator.dart';
import 'categories.dart';

class ExpenseEntry extends StatefulWidget {
  const ExpenseEntry({super.key});

  @override
  State<ExpenseEntry> createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    if (dx < -10) {
      Navigator.of(context).pop();
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 18),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Spending Alerts',
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
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
                              print('Button Pressed');
                            },
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Adjust size based on content
                              children: [
                                Icon(
                                  Icons.check_box_outline_blank,
                                  size: 14,
                                  color: Colors.black87,
                                ),
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
                              print('Button Pressed');
                            },
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Adjust size based on content
                              children: [
                                Icon(
                                  Icons.check_box_outline_blank,
                                  size: 14,
                                  color: Colors.black87,
                                ),
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
                    Center(
                      child: Row(
                        children: [
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
                      onPressed: () {
                        print('Button Pressed');
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
