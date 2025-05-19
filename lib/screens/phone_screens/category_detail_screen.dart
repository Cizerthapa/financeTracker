import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String title;
  final double spent;
  final double budget;
  final double percentage;

  const CategoryDetailScreen({
    super.key,
    required this.title,
    required this.spent,
    required this.budget,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Details'),
        backgroundColor: const Color(0xff0077A3),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category: $title',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              'Spent: ₹${spent.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Budget: ₹${budget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Used: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xff0b2e38),
              ),
              minHeight: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
