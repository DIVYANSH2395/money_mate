import 'package:flutter/material.dart';
import 'package:money_mate/screens/splash/splash_screen.dart';


class MoneyMateApp extends StatelessWidget {
  const MoneyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MoneyMate",
      home: const SplashScreen(),
    );
  }
}