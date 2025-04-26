import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  // Add your home-related state logic here
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
