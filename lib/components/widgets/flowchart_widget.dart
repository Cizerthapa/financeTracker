import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPieChart(List<Map<String, dynamic>> categories) {
  print('[Log] 📊 Received categories: $categories');

  final sections =
      categories
          .where((c) {
            final spent = c['spent'] ?? 0;
            final isValid = spent > 0;
            print(
              '[Log] ➡️ Category "${c['title']}" has spent: $spent -> ${isValid ? "Included" : "Excluded"}',
            );
            return isValid;
          })
          .map((c) {
            final spent = (c['spent'] ?? 0).toDouble();
            final title = c['title'] ?? 'Untitled';
            final color =
                Colors.primaries[categories.indexOf(c) %
                    Colors.primaries.length];

            print(
              '[Log] ✅ Adding pie section: {title: $title, spent: $spent, color: $color}',
            );

            return PieChartSectionData(
              color: color,
              value: spent,
              title: title,
              radius: 50.r,
              titleStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
            );
          })
          .toList();

  print('[Log] 🧩 Total sections generated: ${sections.length}');

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Expense Distribution',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: PieChart(PieChartData(sections: sections)),
            ),
          ],
        ),
      ),
    ),
  );
}
