import 'package:finance_track/providers/transaction_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/login_provider.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  void handleSwipe(BuildContext context, DragUpdateDetails details) {
    double dx = details.delta.dx;
    if (dx < 10) {
      Navigator.of(context).pop();
    }
  }
  late WatchConnectivity watchConnectivity;
  @override
  void initState() {
    super.initState();
    watchConnectivity = WatchConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);
    });
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactionsFromFirebase();

  }

  @override
  void didChangeDependencies() async
  {
    super.didChangeDependencies();
    watchConnectivity = WatchConnectivity();
    Provider.of<LoginProvider>(context).wearOsLogout(watchConnectivity, context);
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final groupedTx = provider.groupedTransactions;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) => handleSwipe(context, details),
        child: Container(
          color: Color(0xFF1D85B1),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Text(
                  'Dec, 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: groupedTx.entries
                              .expand((entry) => entry.value)
                    
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
                                                '\$${item.amount.abs().toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: item.type != 'Income' ? Colors.red : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Icon(
                                                item.amount < 0
                                                    ? Icons
                                                        .arrow_drop_down_sharp
                                                    : Icons.arrow_drop_up_sharp,
                                                color:
                                                    item.amount < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                              Text(
                                                '\$${item.amount.abs().toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      item.amount < 0
                                                          ? Colors.red
                                                          : Colors.green,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
