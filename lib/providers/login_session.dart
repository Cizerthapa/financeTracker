import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class LoginSession with ChangeNotifier {
  late final WatchConnectivity _watchConnectivity;
  bool _userLoggedIn = false;

  bool get userLoggedIn => _userLoggedIn;

  LoginSession() {
    _watchConnectivity = WatchConnectivity();
    _startListening();
  }

  void _startListening() {
    _watchConnectivity.messageStream.listen((message) {
      if (message["UserSession"] == true) {
        _userLoggedIn = true;
      } else {
        _userLoggedIn = false;
      }

      notifyListeners(); // Notify UI to update when the session changes
    });
  }
}
