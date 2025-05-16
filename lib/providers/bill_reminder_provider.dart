import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillReminder {
  final String? id;
  final String title;
  final double amount;
  final DateTime startDate;
  final DateTime dueDate;

  BillReminder({
    this.id,
    required this.title,
    required this.amount,
    required this.startDate,
    required this.dueDate,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
    'startDate': startDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'createdAt': Timestamp.now(),
  };
}

class BillReminderProvider with ChangeNotifier {
  final List<BillReminder> _reminders = [];

  List<BillReminder> get reminders => List.unmodifiable(_reminders);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save reminder under `/users/{uid}/bill_reminders/`
  void addReminder(BillReminder reminder) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bill_reminders')
        .add(reminder.toMap());

    print('[Firestore] Reminder saved with ID: ${docRef.id}');

    _reminders.insert(0, reminder);
    notifyListeners();
  }

  /// Load reminders from `/users/{uid}/bill_reminders/`
  Future<void> fetchReminders() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bill_reminders')
            .orderBy('createdAt', descending: true)
            .get();

    _reminders.clear();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      _reminders.add(
        BillReminder(
          id: doc.id,
          title: data['title'],
          amount: (data['amount'] as num).toDouble(),
          startDate: DateTime.parse(data['startDate']),
          dueDate: DateTime.parse(data['dueDate']),
        ),
      );
    }

    notifyListeners();
  }
}
