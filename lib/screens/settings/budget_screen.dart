import 'package:flutter/material.dart';

double monthlyBudget = 0;
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController budgetController =
      TextEditingController();

  static double monthlyBudget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Budget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Monthly Budget",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  monthlyBudget =
                      double.tryParse(
                            budgetController.text,
                          ) ??
                          0;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Budget Saved",
                    ),
                  ),
                );
              },
              child: const Text("Save Budget"),
            ),

            const SizedBox(height: 30),

            Text(
              "Current Budget : ₹${monthlyBudget.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}