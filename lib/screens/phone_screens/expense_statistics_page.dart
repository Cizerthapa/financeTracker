import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_statistics_provider.dart';
import 'add_budget_page.dart';

class ExpenseStatisticsPage extends StatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  State<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    context.read<ExpenseStatisticsProvider>().fetchBudgets();
    super.initState();
  }

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff0077A3)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      // Optionally update stats provider here
      // context.read<ExpenseStatisticsProvider>().fetchBudgetsForMonth(picked);
    }
  }

  String get formattedMonthYear {
    return DateFormat('MMMM, yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<ExpenseStatisticsProvider>(context);
    final categories = statsProvider.categoryStats;

    return Scaffold(
      backgroundColor: const Color(0xff0077A3),
      appBar: AppBar(
        backgroundColor: const Color(0xff0077A3),
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: _pickMonthYear,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                formattedMonthYear,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        )
      ),
      body: Column(
        children: [
          FutureBuilder<double>(
            future: statsProvider.getTotalBudgetSet(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }

              final totalBudgetSet = snapshot.data ?? 0.0;
              final totalSpend = statsProvider.totalExpenses;
              final progress = totalBudgetSet > 0 ? totalSpend / totalBudgetSet : 0.0;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // const Text(
                    //   "Progress",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: LinearProgressIndicator(
                    //     value: progress,
                    //     backgroundColor: Colors.grey.shade300,
                    //     valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff0b2e38)),
                    //     minHeight: 8,
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    // Text(
                    //   "Spent: \$${totalSpend.toStringAsFixed(2)} / Total Budget: \$${totalBudgetSet.toStringAsFixed(2)}",
                    //   style: const TextStyle(
                    //       color: Colors.black, fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              );
            },
          ),

          // Category List
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final title = category['title'] ?? 'Untitled';
                final percentage = 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${percentage.toStringAsFixed(0)}%"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff0b2e38)),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBudgetPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final String amount;

  const SummaryItem({super.key, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(amount, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
