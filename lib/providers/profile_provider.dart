import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String name = "";
  String profileImage = "https://randomuser.me/api/portraits/men/1.jpg";
  String tagline = "Let's track your expenses.";

  double totalSpent = 12000;
  double budget = 20000;

  Map<String, double> expenses = {
    "Food": 4000,
    "Rent": 4000,
    "Other": 4000,
  };

  ProfileProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        name = userDoc.get('username') ?? "User";
        notifyListeners();
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }
}
