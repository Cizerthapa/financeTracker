import 'package:finance_track/screens/watch_screens/watchwearos_homescreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchwearNotlogin extends StatefulWidget {
  const WatchwearNotlogin({super.key});

  @override
  State<WatchwearNotlogin> createState() => _WatchwearNotloginState();
}

class _WatchwearNotloginState extends State<WatchwearNotlogin> {
  late WatchConnectivity _watchConnectivity;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _watchConnectivity = WatchConnectivity();
    _watchConnectivity.messageStream.listen((message) {
      setState(() async {
        if (message['isWearLoggedIn']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isWearLoggedIn', message['isWearLoggedIn']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WatchwearosHomescreen(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF1D85B1),
        body: Container(
          child: Center(
            child: Text(
              'Not Login!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
