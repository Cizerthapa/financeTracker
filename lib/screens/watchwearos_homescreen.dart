import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';

class WatchwearosHomescreen extends StatefulWidget {
  const WatchwearosHomescreen({super.key});

  @override
  State<WatchwearosHomescreen> createState() => _WatchwearosHomescreenState();
}

class _WatchwearosHomescreenState extends State<WatchwearosHomescreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactionsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final groupedTx = provider.groupedTransactions;
    return Scaffold(
      backgroundColor: Color(0xFF1D85B1),
      body: SingleChildScrollView(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 165,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0))
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.black
                            ),
                          ),
                          Text(
                            '\$30,000',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: groupedTx.entries
                    .expand((entry) => entry.value)
                    .take(2)
                    .map((item) {
                  return Column(
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
                                    item.amount < 0
                                        ? Icons.arrow_drop_down_sharp
                                        : Icons.arrow_drop_up_sharp,
                                    color: item.amount < 0 ? Colors.red : Colors.green,
                                  ),
                                  Text(
                                    '\$${item.amount.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: item.amount < 0 ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
            ),







            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 175,
                height: 70,
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
                        '\$30,000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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