import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String email, String password, WatchConnectivity _watchConnectivity) async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
    isLoggedIN(_watchConnectivity);
    notifyListeners();

  }
  void isLoggedIN(WatchConnectivity _watchConnectivity) async {
    if (await _watchConnectivity.isReachable)
    {
      await _watchConnectivity.sendMessage({
        "isWearLoggedIn": true,
      });
      print("Message is sent");
    }
    else
    {
      print("Mobile is not reachable");
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    notifyListeners();
  }
}
