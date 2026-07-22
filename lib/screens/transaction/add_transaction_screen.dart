import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
 State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController amountController =
      TextEditingController();

  String selectedType = "Expense";
  String selectedCategory = "Food";

  DateTime selectedDate = DateTime.now();

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

  Future<void> saveTransaction() async {

    if (titleController.text.isEmpty ||
        amountController.text.isEmpty) {
      return;
    }

    final transaction = TransactionModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      type: selectedType.toLowerCase(),
      category: selectedCategory,
      date: DateFormat(
        "dd MMM yyyy",
      ).format(selectedDate),
    );

    await DatabaseHelper.instance
        .insertTransaction(transaction);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Transaction Added Successfully"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Transaction"),
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
              value: selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
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
              value: selectedType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
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
                borderRadius:
                    BorderRadius.circular(15),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                DateFormat("dd MMM yyyy")
                    .format(selectedDate),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_calendar),
                onPressed: pickDate,
              ),
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: "Save Transaction",
              onPressed: saveTransaction,
            ),
          ],
        ),
      ),
    );
  }
}