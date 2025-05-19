import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ExpenseStatisticsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double totalIncome = 0;
  List<Map<String, dynamic>> _categories = [];

  double get totalExpenses => _categories.fold(
    0.0,
    (sum, item) => sum + ((item['amount'] ?? 0.0) as num).toDouble(),
  );

  double get total => totalIncome - totalExpenses;

  List<Map<String, dynamic>> get categoryStats => _categories;

  Future<double> getTotalBudgetSet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');
      log('[getTotalBudgetSet] UID: $userUid');

      if (userUid == null) throw Exception('User not logged in');

      final snapshot =
          await _firestore
              .collection('budgets')
              .where('uid', isEqualTo: userUid)
              .get();

      double totalBudgetSet = snapshot.docs.fold(0.0, (sum, doc) {
        return sum + doc['amountLimit'];
      });

      log(
        '[getTotalBudgetSet] Total: $totalBudgetSet for ${snapshot.docs.length} budgets',
      );
      return totalBudgetSet;
    } catch (e, stack) {
      log('❌ [getTotalBudgetSet] Error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> deleteBudget(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');
      log('[deleteBudget] UID: $userUid | Category: $category');

      if (userUid == null) throw Exception('User not logged in');

      final snapshot =
          await _firestore
              .collection('budgets')
              .where('uid', isEqualTo: userUid)
              .get();

      final docToDelete = snapshot.docs.firstWhere(
        (doc) =>
            (doc['category'] as String).toLowerCase() == category.toLowerCase(),
        orElse: () => throw Exception('Category not found'),
      );

      await docToDelete.reference.delete();
      _categories.removeWhere(
        (cat) =>
            (cat['title'] as String).toLowerCase() == category.toLowerCase(),
      );

      log('✅ [deleteBudget] Deleted $category');
      notifyListeners();
    } catch (e, stack) {
      log('❌ [deleteBudget] Error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<double> get totalBudgetSet async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      if (userUid == null) {
        throw Exception('User not logged in');
      }

      final snapshot =
          await _firestore
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
      log(
        'Failed to fetch total budget',
        error: e,
        stackTrace: stack,
        level: 1000,
      );
      throw Exception('Failed to fetch total budget: $e');
    }
  }

  Future<double> getTotalSpendForCategory(
    String category,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      log(
        '[getTotalSpendForCategory] UID: $userUid | Category: $category | From: $startDate | To: $endDate',
      );

      if (userUid == null) throw Exception('User not logged in');

      final snapshot =
          await _firestore
              .collection('transactions')
              .where('uid', isEqualTo: userUid)
              .where('type', isEqualTo: 'expense')
              .where('title', isEqualTo: category)
              .where(
                'timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where(
                'timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate),
              )
              .get();

      log(
        '[getTotalSpendForCategory] Transactions matched: ${snapshot.docs.length}',
      );

      double totalSpend = 0.0;
      for (var doc in snapshot.docs) {
        totalSpend += (doc['amount'] as num).toDouble();
        log(
          '  ↪ Spent: ${doc['amount']} | Title: ${doc['title']} | Time: ${doc['timestamp']}',
        );
      }

      log('[getTotalSpendForCategory] Total Spent: $totalSpend');
      return totalSpend;
    } catch (e, stack) {
      log('❌ [getTotalSpendForCategory] Error', error: e, stackTrace: stack);
      return 0.0;
    }
  }

  Future<void> addBudget(
    String category,
    double amountLimit,
    DateTime startDate,
    DateTime endDate,
  ) async {
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
      _categories.add({'title': category, 'amount': amountLimit});

      log('Added new budget: $newBudget');
      notifyListeners();
    } catch (e, stack) {
      log('Failed to add budget', error: e, stackTrace: stack, level: 1000);
      throw Exception('Failed to add budget: $e');
    }
  }

  Future<void> addOrUpdateBudget(
    String category,
    double amountLimit,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');
      if (userUid == null) throw Exception('User not logged in');

      final snapshot =
          await _firestore
              .collection('budgets')
              .where('uid', isEqualTo: userUid)
              .get();

      QueryDocumentSnapshot<Map<String, dynamic>>? matchingDoc;

      try {
        matchingDoc = snapshot.docs.firstWhere(
          (doc) =>
              (doc['category'] as String).toLowerCase() ==
              category.toLowerCase(),
        );
      } catch (e) {
        matchingDoc = null;
      }

      if (matchingDoc != null) {
        final existingAmount = (matchingDoc['amountLimit'] as num).toDouble();
        final newAmount = existingAmount + amountLimit;

        await matchingDoc.reference.update({
          'amountLimit': newAmount,
          'endDate': endDate,
        });

        log('Updated existing budget for $category: $newAmount');
      } else {
        final newBudget = {
          'category': category,
          'amountLimit': amountLimit,
          'startDate': startDate,
          'endDate': endDate,
          'uid': userUid,
        };

        await _firestore.collection('budgets').add(newBudget);
        log('Created new budget for $category');
      }

      await fetchBudgets();
      notifyListeners();
    } catch (e, stack) {
      log('addOrUpdateBudget error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> fetchBudgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('userUID');

      log('[fetchBudgets] UID: $userUid');

      if (userUid == null) throw Exception('User not logged in');

      final snapshot =
          await _firestore
              .collection('budgets')
              .where('uid', isEqualTo: userUid)
              .get();

      List<Map<String, dynamic>> fetchedCategories = [];

      for (var doc in snapshot.docs) {
        String category = doc['category'];
        double amountLimit = (doc['amountLimit'] as num).toDouble();
        DateTime startDate = (doc['startDate'] as Timestamp).toDate();
        DateTime endDate = (doc['endDate'] as Timestamp).toDate();

        log(
          '[fetchBudgets] Processing: $category | Limit: $amountLimit | Start: $startDate | End: $endDate',
        );

        double totalSpent = await getTotalSpendForCategory(
          category,
          startDate,
          endDate,
        );
        double percentage =
            amountLimit > 0 ? (totalSpent / amountLimit) * 100 : 0.0;

        fetchedCategories.add({
          'title': category,
          'spent': totalSpent,
          'budget': amountLimit,
          'percentage': percentage,
        });

        log(
          '[fetchBudgets] Result → $category: Spent $totalSpent of $amountLimit (${percentage.toStringAsFixed(0)}%)',
        );
      }

      _categories = fetchedCategories;
      log('[fetchBudgets] Total Categories Processed: ${_categories.length}');
      notifyListeners();
    } catch (e, stack) {
      log('❌ [fetchBudgets] Error', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
