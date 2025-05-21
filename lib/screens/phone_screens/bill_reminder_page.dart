import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:finance_track/providers/bill_reminder_provider.dart';

class BillReminderPage extends StatefulWidget {
  const BillReminderPage({super.key});

  @override
  State<BillReminderPage> createState() => _BillReminderPageState();
}

class _BillReminderPageState extends State<BillReminderPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BillReminderProvider>(context, listen: false).fetchReminders();
  }

  void _showAddReminderDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime? startDate;
    DateTime? dueDate;
    String? dateErrorText;

    Future<void> pickDate(
      BuildContext context,
      bool isStart,
      void Function(void Function()) setState,
    ) async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 5),
      );
      if (picked != null) {
        setState(() {
          if (isStart) {
            startDate = picked;
          } else {
            dueDate = picked;
          }
        });
      }
    }

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Bill Reminder'),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Title is required'
                                        : null,
                          ),
                          SizedBox(height: 12.h),
                          TextFormField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Amount is required';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Enter a valid amount';
                              }
                              return null;
                            },
                          ),
                         SizedBox(height: 12.h),
                          ElevatedButton.icon(
                            onPressed: () => pickDate(context, true, setState),
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              startDate == null
                                  ? 'Pick Start Date'
                                  : 'Start: ${startDate!.toLocal().toString().split(' ')[0]}',
                            ),
                          ),
                        SizedBox(height: 8.h),
                          ElevatedButton.icon(
                            onPressed: () => pickDate(context, false, setState),
                            icon: const Icon(Icons.event),
                            label: Text(
                              dueDate == null
                                  ? 'Pick Due Date'
                                  : 'Due: ${dueDate!.toLocal().toString().split(' ')[0]}',
                            ),
                          ),
                          if (startDate != null &&
                              dueDate != null &&
                              dueDate!.isBefore(startDate!))
                             Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Due date must be after start date.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          if (dateErrorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dateErrorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (startDate == null || dueDate == null) {
                            setState(() {
                              dateErrorText = 'Please select both dates';
                            });
                          } else if (dueDate!.isBefore(startDate!)) {
                            setState(() {
                              dateErrorText =
                                  'Due date must be after start date';
                            });
                          } else {
                            final title = titleController.text.trim();
                            final amount = double.parse(
                              amountController.text.trim(),
                            );

                            Provider.of<BillReminderProvider>(
                              context,
                              listen: false,
                            ).addReminder(
                              BillReminder(
                                title: title,
                                amount: amount,
                                startDate: startDate!,
                                dueDate: dueDate!,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<BillReminderProvider>().reminders;

    return Scaffold(
      backgroundColor: const Color(0xFF197BA6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF197BA6),
        elevation: 0,
        title: const Text('Bill Reminder'),
        centerTitle: true,
      ),
      body:
          reminders.isEmpty
              ? const Center(child: Text('No reminders yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return _BillCard(
                    title: reminder.title,
                    amount: reminder.amount,
                    startDate: reminder.startDate,
                    dueDate: reminder.dueDate,
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0B2E38),
        onPressed: () => _showAddReminderDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime startDate;
  final DateTime dueDate;

  const _BillCard({
    required this.title,
    required this.amount,
    required this.startDate,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
         SizedBox(height: 6.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style:  TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B2E38),
            ),
          ),
          SizedBox(height: 8.h),
          Text('Start Date: ${startDate.toLocal().toString().split(' ')[0]}'),
          Text('Due Date: ${dueDate.toLocal().toString().split(' ')[0]}'),
        ],
      ),
    );
  }
}
