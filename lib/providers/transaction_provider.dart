import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String method;
  final double amount;
  final String date;

  Transaction({
    required this.title,
    required this.method,
    required this.amount,
    required this.date,
  });
}

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(
      title: 'Travel',
      method: 'Debit Card',
      amount: -360,
      date: 'Dec 30, Thursday',
    ),
    Transaction(
      title: 'Food',
      method: 'Debit Card',
      amount: -100,
      date: 'Dec 30, Thursday',
    ),
    Transaction(
      title: 'Rent',
      method: 'Debit Card',
      amount: -100,
      date: 'Dec 30, Thursday',
    ),
    Transaction(
      title: 'Income',
      method: 'Debit Card',
      amount: 100,
      date: 'Dec 30, Thursday',
    ),
    Transaction(
      title: 'Travel',
      method: 'Debit Card',
      amount: -360,
      date: 'Dec 7, Saturday',
    ),
    Transaction(
      title: 'Travel',
      method: 'Debit Card',
      amount: -360,
      date: 'Dec 7, Saturday',
    ),
    Transaction(
      title: 'Travel',
      method: 'Debit Card',
      amount: -360,
      date: 'Dec 7, Saturday',
    ),
  ];

  List<Transaction> get transactions => _transactions;

  Map<String, List<Transaction>> get groupedTransactions {
    Map<String, List<Transaction>> map = {};
    for (var tx in _transactions) {
      if (!map.containsKey(tx.date)) {
        map[tx.date] = [];
      }
      map[tx.date]!.add(tx);
    }
    return map;
  }

  double get totalExpenses => _transactions
      .where((t) => t.amount < 0)
      .fold(0, (sum, t) => sum + t.amount.abs());

  double get totalIncome => _transactions
      .where((t) => t.amount > 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalAmount => totalIncome - totalExpenses;
}
