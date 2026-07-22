import 'package:flutter/material.dart';

class BudgetProgressCard extends StatelessWidget {
  final double budget;
  final double expense;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        budget == 0 ? 0.0 : (expense / budget).clamp(0.0, 1.0);

    final remaining = budget - expense;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Monthly Budget",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "₹${expense.toStringAsFixed(0)} / ₹${budget.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 12),

            Text(
              remaining >= 0
                  ? "Remaining ₹${remaining.toStringAsFixed(0)}"
                  : "Exceeded by ₹${(-remaining).toStringAsFixed(0)}",
              style: TextStyle(
                color: remaining >= 0
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}