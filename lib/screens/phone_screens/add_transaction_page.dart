import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_track/model/transaction_model.dart';
import 'package:finance_track/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');

    if (uid == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final newTx = {
      'amount': double.parse(_amountController.text),
      'title': _titleController.text.trim(),
      'method': _selectedMethod,
      'type': _selectedType,
      'date': _dateController.text.trim(),
      'uid': uid,
      'timestamp': Timestamp.now(),
    };

    try {
      await Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTx);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save transaction.')),
      );
    }

    setState(() => _isSaving = false);
  }

  @override
  void initState() {
    super.initState();
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty || double.tryParse(value) == null
                    ? 'Enter a valid amount'
                    : null,
              ),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a title' : null,
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
                items: _methods
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
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
                items: _types
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),

              // Save Button
              const SizedBox(height: 24),
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
