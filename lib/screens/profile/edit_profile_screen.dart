import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;

  late String selectedType;
  late String selectedCategory;
  late DateTime selectedDate;

  final List<String> categories = [
    "Food",
    "Shopping",
    "Travel",
    "Salary",
    "Bills",
    "Health",
    "Entertainment",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.transaction.title,
    );

    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );

    selectedType =
        widget.transaction.type[0].toUpperCase() +
            widget.transaction.type.substring(1);

    selectedCategory = widget.transaction.category;

    try {
      selectedDate = DateFormat(
        "dd MMM yyyy",
      ).parse(widget.transaction.date);
    } catch (_) {
      selectedDate = DateTime.now();
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> updateTransaction() async {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty) {
      return;
    }

    final transaction = TransactionModel(
      id: widget.transaction.id,
      title: titleController.text.trim(),
      amount: double.parse(amountController.text),
      type: selectedType.toLowerCase(),
      category: selectedCategory,
      date: DateFormat(
        "dd MMM yyyy",
      ).format(selectedDate),
      userEmail: widget.transaction.userEmail,
    );

    await DatabaseHelper.instance
        .updateTransaction(transaction);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Transaction Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
              hintText: "Transaction Title",
              prefixIcon: Icons.edit,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: amountController,
              hintText: "Amount",
              prefixIcon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
                            items: const [
                DropdownMenuItem(
                  value: "Income",
                  child: Text("Income"),
                ),
                DropdownMenuItem(
                  value: "Expense",
                  child: Text("Expense"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              leading: const Icon(
                Icons.calendar_today,
              ),
              title: Text(
                DateFormat(
                  "dd MMM yyyy",
                ).format(selectedDate),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.edit_calendar,
                ),
                onPressed: pickDate,
              ),
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: "Update Transaction",
              onPressed: updateTransaction,
            ),
          ],
        ),
      ),
    );
  }
}