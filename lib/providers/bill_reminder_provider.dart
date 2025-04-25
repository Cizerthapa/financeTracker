import 'package:flutter/material.dart';

class BillReminder {
  final String title;
  final double amount;

  BillReminder({required this.title, required this.amount});
}

class BillReminderProvider with ChangeNotifier {
  final List<BillReminder> _reminders = [
    BillReminder(title: 'Car Repair Bill', amount: 12500.00),
    BillReminder(title: 'Credit card payment', amount: 12500.00),
    BillReminder(title: 'Loan from friend', amount: 12500.00),
  ];

  List<BillReminder> get reminders => _reminders;

  void addReminder(BillReminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }
}
