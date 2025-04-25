import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bill_reminder_provider.dart';

class BillReminderPage extends StatelessWidget {
  const BillReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillReminderProvider>(context);
    final reminders = provider.reminders;

    return Scaffold(
      backgroundColor: const Color(0xFF197BA6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF197BA6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text('Bill Reminder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              provider.addReminder(
                BillReminder(title: 'New Bill', amount: 10000.00),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length + 1,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                if (index < reminders.length) {
                  final reminder = reminders[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$ ${reminder.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFF0B2E38),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      provider.addReminder(
                        BillReminder(title: 'New Reminder', amount: 5000.00),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: Color(0xFF0B2E38)),
                          SizedBox(width: 8),
                          Text(
                            'Add Reminder',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF0B2E38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
