import 'package:finance_track/screens/watch_screens/expense_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../providers/login_provider.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    watchConnectivity = WatchConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).wearOsLogout(watchConnectivity, context);
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
