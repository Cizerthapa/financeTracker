import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String name = "Cizer Thapa";
  String profileImage = "https://randomuser.me/api/portraits/men/1.jpg";
  String tagline = "Let's track your expenses.";

  double totalSpent = 12000;
  double budget = 20000;

  Map<String, double> expenses = {"Food": 4000, "Rent": 4000, "Other": 4000};

  void logout() {
    // Perform logout logic
    debugPrint("User logged out");
    // notifyListeners() if state changes
  }
}
