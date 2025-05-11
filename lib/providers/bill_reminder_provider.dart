import 'package:flutter/material.dart';

class BillReminder {
  final String title;
  final double amount;

  BillReminder({required this.title, required this.amount});
}

class BillReminderProvider with ChangeNotifier {
  final List<BillReminder> _reminders = [
    BillReminder(title: 'Car Repair Bill', amount: 12500.00),
    BillReminder(title: 'Credit Card Payment', amount: 8700.00),
    BillReminder(title: 'Loan from Friend', amount: 3000.00),
  ];

  List<BillReminder> get reminders => List.unmodifiable(_reminders);

  void addReminder(BillReminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(int index) {
    _reminders.removeAt(index);
    notifyListeners();
  }

  void updateReminder(int index, BillReminder updatedReminder) {
    _reminders[index] = updatedReminder;
    notifyListeners();
  }
}

