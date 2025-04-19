import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final loginTimestamp = prefs.getInt('loginTimestamp') ?? 0;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final sixtyMinutes = 60 * 60 * 1000;

    if (isLoggedIn && (currentTime - loginTimestamp) < sixtyMinutes) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FinanceHomeScreen()),
      );
    } else {
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF238BBE),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
