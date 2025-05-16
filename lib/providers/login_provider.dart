import 'package:finance_track/screens/watch_screens/authorize.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(
    String email,
    String password,
    WatchConnectivity _watchConnectivity,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
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
    } catch (e) {
      print("Login failed: $e");
      throw Exception('Login Error: $e');
    }
  }

  Future<void> isAccessed(
    String uid,
    WatchConnectivity _watchConnectivity,
  ) async {
    try {
      final isSupported = await _watchConnectivity.isSupported;
      final isReachable = await _watchConnectivity.isReachable;

      if (!isSupported) {
        print("WatchConnectivity not supported on this device.");
        return;
      }

      if (isReachable) {
        await _watchConnectivity.sendMessage({"Accessed": true, "uid": uid});
        print("Access message sent to Wear OS.");
      } else {
        print("Wear OS device is not reachable.");
      }
    } catch (e, stackTrace) {
      print("Error in isAccessed: $e");
      print("StackTrace: $stackTrace");
    }
  }

  void isLoggedIN(WatchConnectivity _watchConnectivity) async {
    try {
      final isSupported = await _watchConnectivity.isSupported;
      final isReachable = await _watchConnectivity.isReachable;

      if (!isSupported) {
        print("WatchConnectivity not supported on this device.");
        return;
      }

      if (isReachable) {
        await _watchConnectivity.sendMessage({"isWearLoggedIn": true});
        print("Message sent to Wear OS.");
      } else {
        print("Wear OS device is not reachable.");
      }
    } catch (e, stackTrace) {
      print("Error in isLoggedIN: $e");
      print("StackTrace: $stackTrace");
    }
  }

  Future<void> logout(WatchConnectivity _watchConnectivity) async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await safeLogoutWatchMessage(_watchConnectivity);

      _isLoggedIn = false;
      notifyListeners();
      print("Logout completed");
    } catch (e, stackTrace) {
      print("Error during logout: $e");
      print("StackTrace: $stackTrace");
    }
  }

  Future<void> safeLogoutWatchMessage(
    WatchConnectivity _watchConnectivity,
  ) async {
    try {
      final isSupported = await _watchConnectivity.isSupported;
      final isReachable = await _watchConnectivity.isReachable;

      if (!isSupported) {
        print("WatchConnectivity not supported on this device.");
        return;
      }

      if (isReachable) {
        await _watchConnectivity.sendMessage({"Logout": true});
        print("Logout message sent to Wear OS.");
      } else {
        print("Wear OS device is not reachable.");
      }
    } catch (e, stackTrace) {
      print("Error in isLogout: $e");
      print("StackTrace: $stackTrace");
    }
  }

  void wearOsLogout(
    WatchConnectivity _watchConnectivity,
    BuildContext context,
  ) async {
    _watchConnectivity.messageStream.listen((message) {
      if (message["Logout"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Authorize()),
        );
      } else {
        print("Can't logout");
      }
      notifyListeners();
    });
  }
}
