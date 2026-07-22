import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../widgets/category_pie_chart.dart';
import '../../services/pdf_service.dart';

class ReportScreen extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  final List<TransactionModel> transactions;

const ReportScreen({
  super.key,
  required this.income,
  required this.expense,
  required this.balance,
  required this.transactions,
});

  @override
  
  Widget build(BuildContext context) {
    Map<String, double> categoryExpense = {};

for (var transaction in transactions) {
  if (transaction.type == "expense") {
    categoryExpense.update(
      transaction.category,
      (value) => value + transaction.amount,
      ifAbsent: () => transaction.amount,
    );
  }
}
    return Scaffold(
      appBar: AppBar(
        actions: [
  IconButton(
    icon: const Icon(Icons.picture_as_pdf),
    onPressed: () {
      PdfService.generateReport(
        income: income,
        expense: expense,
        balance: balance,
      );
    },
  ),
],
        title: const Text("Monthly Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                title: const Text("Total Income"),
                trailing: Text(
                  "₹${income.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.money_off,
                  color: Colors.red,
                ),
                title: const Text("Total Expense"),
                trailing: Text(
                  "₹${expense.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.savings,
                  color: Colors.blue,
                ),
                title: const Text("Current Balance"),
                trailing: Text(
                  "₹${balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
const SizedBox(height: 30),

const Text(
  "Category-wise Expense",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

CategoryPieChart(
  categoryData: categoryExpense,
),
          ],
        ),
      ),
    );
  }
}