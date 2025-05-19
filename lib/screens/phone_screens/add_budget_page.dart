import 'package:finance_track/providers/expense_statistics_provider.dart';
import 'package:finance_track/providers/transaction_provider.dart';
import 'package:finance_track/screens/phone_screens/expense_statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';


class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other',
  ];
  String _selectedCategory = 'Food';

  void _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveBudget() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      await Provider.of<ExpenseStatisticsProvider>(
        context,
        listen: false,
      ).addOrUpdateBudget(
        _selectedCategory,
        double.parse(_amountController.text.trim()),
        _startDate!,
        _endDate!,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Budget', style: TextStyle(fontSize: 18.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 12.h),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount Limit',
                  labelStyle: TextStyle(fontSize: 14.sp),
                ),
                style: TextStyle(fontSize: 14.sp),
                validator:
                    (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Enter a valid amount'
                            : null,
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    _categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        _startDate == null
                            ? 'Start Date'
                            : _startDate!.toLocal().toString().split(' ')[0],
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(
                        _endDate == null
                            ? 'End Date'
                            : _endDate!.toLocal().toString().split(' ')[0],
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBudget,
                  child: Text('Save Budget', style: TextStyle(fontSize: 14.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
