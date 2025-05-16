
import 'package:finance_track/screens/watch_screens/authorize.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import '../watch_screens/watchwearos_homescreen.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isWear;
  const SplashScreen({super.key, required this.isWear});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late WatchConnectivity _watchConnectivity;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _watchConnectivity = WatchConnectivity();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // final isWearOsLoggedIn = prefs.getBool('isWearLoggedIn') ?? false;
    final loginTimestamp = prefs.getInt('loginTimestamp') ?? 0;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final sixtyMinutes = 60 * 60 * 1000;

    if(widget.isWear)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Authorize()),
        );
        // if (isWearOsLoggedIn && (currentTime - loginTimestamp) < sixtyMinutes) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const WatchwearosHomescreen()),
        //   );
        // }
        // else
        //   {
        //     await prefs.clear();
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const WatchwearNotlogin()),
        //     );
        //   }


      }
    else
    {
      if (isLoggedIn && (currentTime - loginTimestamp) < sixtyMinutes)
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FinanceHomeScreen()),
        );
      }
      else
        {
          await prefs.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }

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
