import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text("Amount : ₹${transaction.amount}"),
                const SizedBox(height: 10),

                Text("Type : ${transaction.type}"),
                const SizedBox(height: 10),

                Text("Category : ${transaction.category}"),
                const SizedBox(height: 10),

                Text("Date : ${transaction.date}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}