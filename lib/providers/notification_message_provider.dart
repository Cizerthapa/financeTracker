import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  final List<String> _messages = [];

  List<String> get messages => List.unmodifiable(_messages);

  void addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
