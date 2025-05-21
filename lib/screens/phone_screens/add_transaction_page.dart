import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isSaving = false;

  String _selectedMethod = 'Cash';
  String _selectedType = 'Expense';
  DateTime _selectedDate = DateTime.now();

  final List<String> _methods = ['Cash', 'Card', 'eWallet'];
  final List<String> _types = ['Income', 'Expense'];

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other',
  ];
  String _selectedCategory = 'Food';
  final TextEditingController _customCategoryController =
      TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMMd().format(picked);
      });
    }
  }

  late WatchConnectivity _watchConnectivity = WatchConnectivity();

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');

    if (uid == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in.')));
      return;
    }
    print(double.parse(_amountController.text));
    print(_titleController.text.trim());
    print(_selectedMethod);
    print(_selectedType);
    print(_dateController.text.trim());
    print(uid);
    print(Timestamp.now());

    final String title =
        _selectedCategory == 'Other'
            ? _customCategoryController.text.trim()
            : _selectedCategory;

    final newTx = {
      'amount': double.parse(_amountController.text),
      'title': title,
      'method': _selectedMethod,
      'type': _selectedType.toLowerCase(),
      'date': _dateController.text.trim(),
      'uid': uid,
      'timestamp': Timestamp.fromDate(_selectedDate),
    };

    try {
      await Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(newTx);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction saved!')));

      // Watch Notification
      sendNotification('New $title $_selectedType is Added!');

      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save transaction.')),
      );
    }

    setState(() => _isSaving = false);
  }

  void getAllBudgets() async {
    final prefs = await SharedPreferences.getInstance();

    final uid = prefs.getString('userUID');

    List<Map<String, dynamic>> userBudgets = await fetchUserBudgets(uid!);
    log('the above is Budget');
    print(userBudgets.toString());
  }

  Future<List<Map<String, dynamic>>> fetchUserBudgets(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('budgets')
            .where('uid', isEqualTo: uid)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void updateBudgetSpent() {}

  void sendNotification(String name) async {
    try {
      if (await _watchConnectivity.isSupported &&
          await _watchConnectivity.isReachable) {
        await _watchConnectivity.sendMessage({'notification': name});
        print('Message sent to wearable');
      } else {
        print('Wearable not supported or not reachable');
      }
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBudgets();
    _dateController.text = DateFormat.yMMMMd().format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: const Color(0xff0077A3),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null ||
                                value.isEmpty ||
                                double.tryParse(value) == null
                            ? 'Enter a valid amount'
                            : null,
              ),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              if (_selectedCategory == 'Other')
                TextFormField(
                  controller: _customCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Category',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              DropdownButtonFormField<String>(
                value: _selectedMethod,
                items:
                    _methods
                        .map(
                          (method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Method'),
              ),

              DropdownButtonFormField<String>(
                value: _selectedType,
                items:
                    _types
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),

              SizedBox(height: 24.h),

              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0077A3),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Transaction'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
