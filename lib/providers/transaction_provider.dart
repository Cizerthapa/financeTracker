import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track/model/transaction_model.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get totalExpenses => _transactions
      .where((t) => t.amount < 0)
      .fold(0.0, (sum, t) => sum + t.amount);
  double get totalIncome => _transactions
      .where((t) => t.amount > 0)
      .fold(0.0, (sum, t) => sum + t.amount);
  double get totalAmount => totalIncome + totalExpenses;

  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> map = {};
    for (var tx in _transactions) {
      map.putIfAbsent(tx.date, () => []).add(tx);
    }
    return map;
  }

  Future<void> fetchTransactionsFromFirebase() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('transactions').get();

    _transactions =
        snapshot.docs.map((doc) {
          final data = doc.data();

          return TransactionModel(
            title: data['title'] ?? '',
            amount: (data['amount'] ?? 0).toDouble(),
            method: data['method'] ?? '',
            date: data['date'] ?? '',
          );
        }).toList();

    notifyListeners();
  }
}
