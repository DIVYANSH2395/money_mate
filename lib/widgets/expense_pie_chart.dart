import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final double income;
  final double expense;

  const ExpensePieChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Income vs Expense",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 55,
                sections: [
                  PieChartSectionData(
                    value: income == 0 ? 1 : income,
                    color: Colors.green,
                    radius: 70,
                    title: "Income",
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: expense == 0 ? 1 : expense,
                    color: Colors.red,
                    radius: 70,
                    title: "Expense",
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(width: 6),
                  Text("Income"),
                ],
              ),
              Row(
                children: const [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 6),
                  Text("Expense"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}