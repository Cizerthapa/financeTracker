
import 'package:finance_track/providers/login_session.dart';
import 'package:finance_track/screens/phone_screens/profile_screen.dart';
import 'package:finance_track/screens/phone_screens/transaction_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import 'bill_reminder_page.dart';
import 'expense_statistics_page.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({super.key});

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    TransactionSummaryPage(),
    ExpenseStatisticsPage(),
    BillReminderPage(),
    const ProfilePage(),
  ];


  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  final WatchConnectivity _watchConnectivity = WatchConnectivity();


  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final isLoggedIn = context.watch<LoginSession>().userLoggedIn;

    if (isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      bool? mobileLoginIn = prefs.getBool("isLoggedIn");
      if (mobileLoginIn == true) {
        final uid = prefs.getString('userUID');
        isAccessed(uid);
        print("User is logged in.");
      } else {
        print("User is NOT logged in.");
      }
    } else {
      print("Send Item is false");
    }
  }

  void isAccessed(final uid) async {
    if (await _watchConnectivity.isReachable) {
      await _watchConnectivity.sendMessage({
        "Accessed": true,
        "uid": uid,
      });
      print("Message is sent to Mobile OS");
    } else {
      print("Mobile OS device is not reachable");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
