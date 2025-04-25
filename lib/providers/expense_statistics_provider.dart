import 'package:flutter/material.dart';

class ExpenseStatisticsProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _categories = [
    {'title': 'Food', 'amount': 1000.0},
    {'title': 'Travel', 'amount': 3000.0},
    {'title': 'Rent', 'amount': 6000.0},
  ];

  double get totalExpenses =>
      _categories.fold(0.0, (sum, item) => sum + item['amount']);
  double get totalIncome => 10000.0;
  double get total => totalIncome - totalExpenses;

  List<Map<String, dynamic>> get categoryStats {
    return _categories.map((cat) {
      double percentage = (cat['amount'] / totalExpenses) * 100;
      return {'title': cat['title'], 'percentage': percentage};
    }).toList();
  }
}
