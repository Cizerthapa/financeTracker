import 'package:finance_track/components/widgets/flowchart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    }
  }

  String get formattedMonthYear {
    return DateFormat('MMMM, yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<ExpenseStatisticsProvider>(context);
    final categories = [
      {'title': 'Food', 'spent': 3200.0, 'budget': 4000.0, 'percentage': 80.0},
      {
        'title': 'Transport',
        'spent': 1500.0,
        'budget': 3000.0,
        'percentage': 50.0,
      },
      {
        'title': 'Shopping',
        'spent': 800.0,
        'budget': 2000.0,
        'percentage': 40.0,
      },
    ];

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
              Icon(Icons.calendar_month, size: 20.sp, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                formattedMonthYear,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<double>(
            future: statsProvider.getTotalBudgetSet(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: const CircularProgressIndicator(),
                );
              }

              final totalBudgetSet = snapshot.data ?? 0.0;
              final totalSpend = statsProvider.totalExpenses;
              final progress =
                  totalBudgetSet > 0 ? totalSpend / totalBudgetSet : 0.0;

              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      'Spent: ₹${totalSpend.toStringAsFixed(2)} / Budget: ₹${totalBudgetSet.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    buildPieChart(categories),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final title = (category['title'] ?? 'Untitled') as String;
                final spent = (category['spent'] as num?)?.toDouble() ?? 0.0;
                final budget = (category['budget'] as num?)?.toDouble() ?? 0.0;
                final percentage = budget > 0 ? (spent / budget) * 100 : 0.0;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xff0b2e38),
                            ),
                            minHeight: 8.h,
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
        child: Icon(Icons.add, color: Colors.black, size: 24.sp),
      ),
    );
  }
}
