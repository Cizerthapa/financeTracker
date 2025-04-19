import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  List<Map<String, String>> _registeredUsers = [];

  List<Map<String, String>> get users => _registeredUsers;

  bool register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) {
    final alreadyExists = _registeredUsers.any((user) => user['email'] == email);

    if (alreadyExists) {
      return false;
    }

    // Save user
    _registeredUsers.add({
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    });

    notifyListeners();
    return true;
  }
}
