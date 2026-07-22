import 'package:flutter/material.dart';

class EmptyTransaction extends StatelessWidget {
  final VoidCallback onPressed;

  const EmptyTransaction({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 90,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Transactions Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap the button below to add your first transaction.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add),
              label: const Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}