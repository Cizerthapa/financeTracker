import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/transaction_model.dart';

class WatchAddTransaction with ChangeNotifier
{

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> addTransaction(Map<String, dynamic> newTransaction) async {
    await FirebaseFirestore.instance
        .collection('transactions')
        .add(newTransaction);

    final txModel = TransactionModel.fromMap(newTransaction);
    _transactions.add(txModel);
    notifyListeners();
  }

  double get totalExpenses => _transactions
      .where((t) => t.type?.toLowerCase() == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => _transactions
      .where((t) => t.type?.toLowerCase() == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalAmount => totalIncome - totalExpenses;

  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> map = {};
    for (var tx in _transactions) {
      map.putIfAbsent(tx.date, () => []).add(tx);
    }
    return map;
  }



}