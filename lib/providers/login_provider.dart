import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password, WatchConnectivity _watchConnectivity) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        _isLoggedIn = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
        await prefs.setString('userUID', user.uid);

        isLoggedIN(_watchConnectivity);

        notifyListeners();
      }
    } catch (e) {
      print("Login failed: $e");
      throw Exception('Login Error: $e');
    }
  }

  void isLoggedIN(WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable) {
      await _watchConnectivity.sendMessage({
        "isWearLoggedIn": true,
      });
      print("Message is sent to Wear OS");
    } else {
      print("Wear OS device is not reachable");
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    notifyListeners();
  }
}
