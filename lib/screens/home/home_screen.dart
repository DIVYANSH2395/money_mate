import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../database/database_helper.dart';
import '../../models/transaction_model.dart';

import '../../widgets/balance_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/empty_transaction.dart';
import '../../widgets/expense_pie_chart.dart';
import '../../widgets/search_box.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/weekly_bar_chart.dart';

import '../auth/login_screen.dart';
import '../reports/report_screen.dart';
import '../settings/budget_screen.dart';
import '../transaction/add_transaction_screen.dart';
import '../transaction/edit_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<TransactionModel> transactions = [];
  List<TransactionModel> filteredTransactions = [];

  final TextEditingController searchController =
      TextEditingController();

  double totalIncome = 0;
  double totalExpense = 0;
  double totalBalance = 0;

  double monthlyBudget = 0;

  String selectedFilter = "All";

  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    userName =
        prefs.getString("userName") ?? "";

    userEmail =
        prefs.getString("userEmail") ?? "";

    await loadTransactions();

    filteredTransactions =
        List.from(transactions);

    setState(() {});
  }

  Future<void> loadTransactions() async {

    transactions =
        await DatabaseHelper.instance
            .getTransactions(userEmail);

    totalIncome = 0;
    totalExpense = 0;

    for (var t in transactions) {

      if (t.type == "income") {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }

    totalBalance =
        totalIncome - totalExpense;

    filteredTransactions =
        List.from(transactions);

    if (!mounted) return;

    setState(() {});

    if (monthlyBudget > 0 &&
        totalExpense > monthlyBudget) {

      WidgetsBinding.instance
          .addPostFrameCallback((_) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "⚠ Budget Exceeded by ₹${(totalExpense - monthlyBudget).toStringAsFixed(2)}",
            ),
          ),
        );
      });
    }
  }

  void applyFilters() {

    setState(() {

      filteredTransactions =
          transactions.where((transaction) {

        final matchesSearch =
            transaction.title
                .toLowerCase()
                .contains(
                  searchController.text
                      .toLowerCase(),
                );

        final matchesFilter =
            selectedFilter == "All"
                ? true
                : transaction.type
                        .toLowerCase() ==
                    selectedFilter
                        .toLowerCase();

        return matchesSearch &&
            matchesFilter;

      }).toList();
    });
  }

  IconData getCategoryIcon(
      String category) {

    switch (category) {

      case "Food":
        return Icons.fastfood;

      case "Shopping":
        return Icons.shopping_bag;

      case "Travel":
        return Icons.directions_car;

      case "Salary":
        return Icons.account_balance_wallet;

      case "Bills":
        return Icons.receipt_long;

      case "Health":
        return Icons.local_hospital;

      case "Entertainment":
        return Icons.movie;

      default:
        return Icons.category;
    }
  }

  Color getCategoryColor(
      String category) {

    switch (category) {

      case "Food":
        return Colors.orange;

      case "Shopping":
        return Colors.purple;

      case "Travel":
        return Colors.blue;

      case "Salary":
        return Colors.green;

      case "Bills":
        return Colors.red;

      case "Health":
        return Colors.pink;

      case "Entertainment":
        return Colors.indigo;

      default:
        return Colors.grey;
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xffF8FAFC),

    bottomNavigationBar: BottomNavBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    ),

    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Good Morning 👋",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            userName.isEmpty ? "User" : userName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),

      actions: [

        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportScreen(
                  income: totalIncome,
                  expense: totalExpense,
                  balance: totalBalance,
                  transactions: transactions,
                ),
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(
            Icons.account_balance_wallet,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const BudgetScreen(),
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {

            final prefs =
                await SharedPreferences.getInstance();

            await prefs.clear();

            if (!mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LoginScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ],
    ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add),
      onPressed: () async {

        final result =
            await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AddTransactionScreen(),
          ),
        );

        if (result == true) {
          loadTransactions();
        }
      },
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          BalanceCard(
            balance: totalBalance,
          ),

          const SizedBox(height: 25),

          ExpensePieChart(
            income: totalIncome,
            expense: totalExpense,
          ),

          BudgetProgressCard(
            budget: monthlyBudget,
            expense: totalExpense,
          ),

          const SizedBox(height: 25),

          const WeeklyBarChart(),

          const SizedBox(height: 25),

          Row(
            children: [

              SummaryCard(
                title: "Income",
                amount:
                    "₹${totalIncome.toStringAsFixed(0)}",
                icon: Icons.arrow_downward,
                color: Colors.green,
              ),

              const SizedBox(width: 15),

              SummaryCard(
                title: "Expense",
                amount:
                    "₹${totalExpense.toStringAsFixed(0)}",
                icon: Icons.arrow_upward,
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 30),
                    SearchBox(
            controller: searchController,
            onChanged: (value) {
              applyFilters();
            },
          ),

          const SizedBox(height: 15),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text("All"),
                  selected: selectedFilter == "All",
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = "All";
                      applyFilters();
                    });
                  },
                ),

                const SizedBox(width: 10),

                FilterChip(
                  label: const Text("Income"),
                  selected: selectedFilter == "Income",
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = "Income";
                      applyFilters();
                    });
                  },
                ),

                const SizedBox(width: 10),

                FilterChip(
                  label: const Text("Expense"),
                  selected: selectedFilter == "Expense",
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = "Expense";
                      applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Recent Transactions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 20),

          filteredTransactions.isEmpty
              ? EmptyTransaction(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AddTransactionScreen(),
                      ),
                    );

                    if (result == true) {
                      loadTransactions();
                    }
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction =
                        filteredTransactions[index];

                    return Dismissible(
                      key: Key(
                        transaction.id.toString(),
                      ),

                      background: Container(
                        alignment:
                            Alignment.centerRight,
                        padding:
                            const EdgeInsets.only(
                                right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),

                      onDismissed: (direction) async {
                        await DatabaseHelper.instance
                            .deleteTransaction(
                                transaction.id!);

                        loadTransactions();

                        if (!mounted) return;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Transaction Deleted",
                            ),
                          ),
                        );
                      },

                      child: GestureDetector(
                        onTap: () async {
                          final result =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditTransactionScreen(
                                transaction:
                                    transaction,
                              ),
                            ),
                          );

                          if (result == true) {
                            loadTransactions();
                          }
                        },

                        child: TransactionCard(
                          icon: getCategoryIcon(
                              transaction.category),
                          title: transaction.title,
                          date: transaction.date,
                          amount:
                              "${transaction.type == "income" ? "+" : "-"} ₹${transaction.amount}",
                          color: getCategoryColor(
                              transaction.category),
                        ),
                      ),
                    );
                  },
                ),

          const SizedBox(height: 100),
        ],
      ),
    ),
  );
}
}