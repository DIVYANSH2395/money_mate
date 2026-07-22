import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
  });

  final List<Color> colors = const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const Center(
        child: Text("No Expense Data"),
      );
    }

    int index = 0;

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: categoryData.entries.map((entry) {
            final color = colors[index % colors.length];
            index++;

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: entry.key,
              radius: 70,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}