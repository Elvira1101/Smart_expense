import 'package:app_expense/Screen/Depenses_pages.dart';
import 'package:flutter/material.dart';
import 'features/auth/login.dart';
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
        '/login':(context)=> LoginPage(),
        '/depenses':(context)=>DepensesPage()
      },
    );
  }
}