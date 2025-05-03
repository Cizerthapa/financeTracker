import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/transaction_provider.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController =
  TextEditingController(text: "December, 2024");
  final TextEditingController _methodController =
  TextEditingController(text: "Cash");
  final TextEditingController _titleController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newTx = {
      'amount': double.parse(_amountController.text),
      'title': _titleController.text.trim(),
      'method': _methodController.text.trim(),
      'date': _dateController.text.trim(),
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
                decoration:
                const InputDecoration(labelText: 'Date (e.g. December, 2024)'),
              ),
              TextFormField(
                controller: _methodController,
                decoration: const InputDecoration(labelText: 'Method (e.g. Cash)'),
              ),
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
