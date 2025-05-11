import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ExpenseStatisticsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double totalIncome = 0;
  List<Map<String, dynamic>> _categories = [];

  double get totalExpenses =>
      _categories.fold(0.0, (sum, item) => sum + item['amount']);

  double get total => totalIncome - totalExpenses;

  List<Map<String, dynamic>> get categoryStats {
    return _categories.map((cat) {
      double percentage = (cat['amount'] / totalExpenses) * 100;
      return {'title': cat['title'], 'percentage': percentage};
    }).toList();
  }

  Future<double> getTotalBudgetSet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      if (userUid == null) {
        throw Exception('User not logged in');
      }

      final snapshot = await _firestore
          .collection('budgets')
          .where('uid', isEqualTo: userUid)
          .get();

      double totalBudgetSet = snapshot.docs.fold(0.0, (sum, doc) {
        return sum + doc['amountLimit'];
      });

      log('Total budget set: $totalBudgetSet');
      return totalBudgetSet;
    } catch (e, stack) {
      log('Failed to get total budget set', error: e, stackTrace: stack, level: 1000);
      throw Exception('Failed to get total budget set: $e');
    }
  }

  Future<double> get totalBudgetSet async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      if (userUid == null) {
        throw Exception('User not logged in');
      }

      final snapshot = await _firestore
          .collection('budgets')
          .where('uid', isEqualTo: userUid)
          .get();

      double totalBudget = 0.0;
      for (var doc in snapshot.docs) {
        totalBudget += doc['amountLimit'];
      }

      log('Computed totalBudgetSet: $totalBudget');
      return totalBudget;
    } catch (e, stack) {
      log('Failed to fetch total budget', error: e, stackTrace: stack, level: 1000);
      throw Exception('Failed to fetch total budget: $e');
    }
  }

  // Future<double> getTotalSpendForCategory(String category) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final userUid = prefs.getString('userUID');
  //
  //     if (userUid == null) {
  //       throw Exception('User not logged in');
  //     }
  //
  //     final budgetSnapshot = await _firestore
  //         .collection('budgets')
  //         .where('uid', isEqualTo: userUid)
  //         .where('category', isEqualTo: category)
  //         .get();
  //
  //     if (budgetSnapshot.docs.isEmpty) {
  //       throw Exception('No budget found for category $category');
  //     }
  //
  //     var budgetDoc = budgetSnapshot.docs.first;
  //     DateTime startDate = budgetDoc['startDate'].toDate();
  //     DateTime endDate = budgetDoc['endDate'].toDate();
  //
  //     log('Fetching expenses from $startDate to $endDate for category $category');
  //
  //     final snapshot = await _firestore
  //         .collection('transactions')
  //         .where('uid', isEqualTo: userUid)
  //         .where('type', isEqualTo: 'expense')
  //         .where('timestamp', isGreaterThanOrEqualTo: startDate)
  //         .get();
  //
  //     double totalSpend = 0.0;
  //     for (var doc in snapshot.docs) {
  //       log('Expense found: ${doc.data()}');
  //       totalSpend += doc['amount'];
  //     }
  //
  //     log('Total spent in $category: $totalSpend');
  //     return totalSpend;
  //   } catch (e, stack) {
  //     log('Error fetching total spend for $category', error: e, stackTrace: stack, level: 1000);
  //     throw Exception('Failed to fetch total spend for category $category: $e');
  //   }
  // }

  Future<void> addBudget(String category, double amountLimit, DateTime startDate, DateTime endDate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      if (userUid == null) {
        throw Exception('User not logged in');
      }

      final docRef = _firestore.collection('budgets').doc();

      final newBudget = {
        'category': category,
        'amountLimit': amountLimit,
        'startDate': startDate,
        'endDate': endDate,
        'uid': userUid,
      };

      await docRef.set(newBudget);
      _categories.add({
        'title': category,
        'amount': amountLimit,
      });

      log('Added new budget: $newBudget');
      notifyListeners();
    } catch (e, stack) {
      log('Failed to add budget', error: e, stackTrace: stack, level: 1000);
      throw Exception('Failed to add budget: $e');
    }
  }

  Future<void> fetchBudgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      if (userUid == null) {
        throw Exception('User not logged in');
      }

      log('Fetching budgets for user: $userUid');

      final snapshot = await _firestore
          .collection('budgets')
          .where('uid', isEqualTo: userUid)
          .get();

      List<Map<String, dynamic>> fetchedCategories = [];
      for (var doc in snapshot.docs) {
        String category = doc['category'];
        double amountLimit = doc['amountLimit'];

        log('Processing category: $category with limit: $amountLimit');

        //double totalSpendForCategory = await getTotalSpendForCategory(category);

        fetchedCategories.add({
          'title': category,
          'amount': amountLimit,
          //'totalSpent': totalSpendForCategory,
        });
      }

      _categories = fetchedCategories;
      log('Updated _categories with ${_categories.length} entries');
      notifyListeners();
    } catch (e, stack) {
      log('Failed to fetch budgets', error: e, stackTrace: stack, level: 1000);
      throw Exception('Failed to fetch budgets: $e');
    }
  }
}
