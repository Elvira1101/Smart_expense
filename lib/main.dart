import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'Screen/DashboardPage.dart';

void main() {
  runApp(const SmartExpenseApp());
}

class SmartExpenseApp extends StatelessWidget {
  const SmartExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),


      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}