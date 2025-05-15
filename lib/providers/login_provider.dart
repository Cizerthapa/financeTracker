import 'package:flutter/cupertino.dart';
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

        notifyListeners();
      }
    } catch (e) {
      print('Login failed: $e');
      throw Exception('Login Error: $e');
    }
  }

  Future<void> isLoggedIN(WatchConnectivity watchConnectivity) async {
    try {
      final bool reachable = await watchConnectivity.isReachable;

      if (reachable) {
        await watchConnectivity.sendMessage({'isWearLoggedIn': true});
        debugPrint('Message sent to Wear OS: isWearLoggedIn=true');
      } else {
        debugPrint('Wear OS device is not reachable.');
      }
    } catch (e) {
      debugPrint('Error sending message to Wear OS: $e');
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
