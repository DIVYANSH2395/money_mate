import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../reports/report_screen.dart';
import '../settings/budget_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
  const HomeScreen(),
  const ReportScreen(),
  const BudgetScreen(),
  const ProfileScreen(),
];

return Scaffold(
  body: IndexedStack(
    index: currentIndex,
    children: pages,
  ),

  bottomNavigationBar: BottomNavigationBar(
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,

    onTap: (index) {
      setState(() {
        currentIndex = index;
      });
    },

    selectedItemColor: Colors.green,

    unselectedItemColor: Colors.grey,

    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: "Reports",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet),
        label: "Budget",
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profile",
      ),
    ],
  ),
);
  }
}