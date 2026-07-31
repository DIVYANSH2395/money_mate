import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';
import '../../services/pdf_service.dart';
import '../../widgets/category_pie_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<TransactionModel> transactions = [];

  bool isLoading = true;

  double income = 0;
  double expense = 0;
  double balance = 0;

  Map<String, double> categoryExpense = {};

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final userEmail =
        prefs.getString("userEmail") ?? "";

    final data = await DatabaseHelper.instance
        .getTransactions(userEmail);

    double totalIncome = 0;
    double totalExpense = 0;

    Map<String, double> categoryMap = {};

    for (var transaction in data) {
      if (transaction.type == "income") {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;

        categoryMap.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }

    setState(() {
      transactions = data;

      income = totalIncome;
      expense = totalExpense;
      balance = totalIncome - totalExpense;

      categoryExpense = categoryMap;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

return Scaffold(
  appBar: AppBar(
    title: const Text("Monthly Report"),
    centerTitle: true,
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
  ),

  body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        fontSize: 18,
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
        fontSize: 18,
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
        fontSize: 18,
      ),
    ),
  ),
),

const SizedBox(height: 30),

const Center(
  child: Text(
    "Category-wise Expense",
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 20),

categoryExpense.isEmpty
    ? const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No expense data available.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
    : SizedBox(
        height: 300,
        child: CategoryPieChart(
          categoryData: categoryExpense,
        ),
      ),
            ],
    ),
  ),
);
  }
}