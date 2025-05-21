import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillReminderProvider>(context, listen: false)
          .fetchReminders();
    });
  }

  void _showAddReminderDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime? startDate;
    DateTime? dueDate;
    String? dateErrorText;
    bool isSaving = false;

    Future<void> pickDate(
        BuildContext context, bool isStart, void Function(void Function()) setState) async {
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

    Future<void> addReminder() async {
      setState(() {
        isSaving = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userUID');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        setState(() {
          isSaving = false;
        });
        return;
      }

      final uuid = Uuid();

      try {
        await Provider.of<BillReminderProvider>(
          context,
          listen: false,
        ).addReminder(
          BillReminder(
            id: uuid.v4(),
            title: titleController.text.trim(),
            amount: double.parse(amountController.text.trim()),
            startDate: startDate!,
            dueDate: dueDate!,
            userId: userId,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill reminder added!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add reminder.')),
        );
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Bill Reminder'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount'),
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Due date must be after start date.',
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ),
                  if (dateErrorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        dateErrorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            if (!isSaving)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            isSaving
                ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  if (startDate == null || dueDate == null) {
                    setState(() {
                      dateErrorText = 'Please select both dates';
                    });
                  } else if (dueDate!.isBefore(startDate!)) {
                    setState(() {
                      dateErrorText = 'Due date must be after start date';
                    });
                  } else {
                    setState(() {
                      dateErrorText = null;
                    });
                    addReminder();
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
    return Consumer<BillReminderProvider>(
      builder: (context, provider, _) {
        final reminders = provider.reminders;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bill Reminders'),
            backgroundColor: const Color(0xff0077A3),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : reminders.isEmpty
              ? const Center(
            child: Text(
              'No bill reminders found. Tap + to add.',
              style: TextStyle(fontSize: 16),
            ),
          )
              : ListView.separated(
            itemCount: reminders.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final r = reminders[index];
              return Dismissible(
                key: Key(r.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => provider.deleteReminder(r.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: const Icon(Icons.notifications_active_rounded,
                      color: Colors.blue),
                  title: Text(
                    r.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due on: ${r.dueDate.toLocal().toString().split(' ')[0]}'),
                      Text('Amount: \$${r.amount.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Checkbox(
                    value: r.status == 'complete',
                    onChanged: (val) {
                      if (val == true) {
                        provider.markAsComplete(r.id);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddReminderDialog(context),
            backgroundColor: const Color(0xff0077A3),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
