import 'package:finance_track/screens/watch_screens/authorize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password, WatchConnectivity _watchConnectivity) async
  {

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null)
      {
        _isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt(
          'loginTimestamp',
          DateTime.now().millisecondsSinceEpoch,
        );
        await prefs.setString('userUID', user.uid);

        isLoggedIN(_watchConnectivity);
        isAccessed(user.uid, _watchConnectivity);

        notifyListeners();
      }
    }
    catch (e)
    {
      print("Login failed: $e");
      throw Exception('Login Error: $e');
    }
  }

  void isAccessed(final uid, WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable)
    {
      await _watchConnectivity.sendMessage({
        "Accessed": true,
        "uid": uid,
      });
      print("Message is sent to Mobile OS");
    }
    else
    {
      print("Mobile OS device is not reachable");
    }
  }

  void isLoggedIN(WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable)
    {
      await _watchConnectivity.sendMessage({
        "isWearLoggedIn": true,
      });
      print("Message is sent to Wear OS");
    }
    else
    {
      print("Wear OS device is not reachable");
    }
  }


  void isLogout(WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable)
    {
      await _watchConnectivity.sendMessage({
        "Logout": true,
      });
      print("Message is sent to Wear OS");
    }
    else
    {
      print("Wear OS device is not reachable");
    }
  }

   void wearOsLogout(WatchConnectivity _watchConnectivity, BuildContext context) async {
    _watchConnectivity.messageStream.listen((message) {
      if (message["Logout"] == true)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Authorize()));
      }
      else
      {
       print("Can't logout");
      }
      notifyListeners();
    });
  }


  Future<void> logout(WatchConnectivity _watchConnectivity) async {
    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    isLogout(_watchConnectivity);

    _isLoggedIn = false;
    notifyListeners();
  }
}
