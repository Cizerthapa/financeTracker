import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_statistics_provider.dart'; // Ensure this path is correct

class ExpenseStatisticsPage extends StatelessWidget {
  const ExpenseStatisticsPage({super.key});

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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios, size: 16),
            SizedBox(width: 4),
            Text("December, 2024"),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SummaryItem(
                  label: "Expenses",
                  amount: "\$${statsProvider.totalExpenses.toStringAsFixed(2)}",
                ),
                SummaryItem(
                  label: "Income",
                  amount: "\$${statsProvider.totalIncome.toStringAsFixed(2)}",
                ),
                SummaryItem(
                  label: "Total",
                  amount: "\$${statsProvider.total.toStringAsFixed(2)}",
                ),
              ],
            ),
          ),

          // Category Breakdown
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
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
                        // Title and Percentage
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${category['percentage'].toStringAsFixed(0)}%",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: category['percentage'] / 100,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xff0b2e38),
                            ),
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
