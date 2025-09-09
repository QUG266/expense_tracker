import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> dailyExpenses; // length = số ngày trong tháng
  const MonthlyBarChart({super.key, required this.dailyExpenses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (int i = 0; i < dailyExpenses.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [BarChartRodData(toY: dailyExpenses[i], width: 6)],
              ),
          ],
        ),
      ),
    );
  }
}
