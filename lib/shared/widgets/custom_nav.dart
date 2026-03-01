import 'package:flutter/material.dart';
import '../../Screen/DashboardPage.dart';
import '../../Screen/Depenses_pages.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      onTap: (index) {
        // Si l'utilisateur clique sur l'onglet actuel, on ne fait rien
        if (index == currentIndex) return;

        switch (index) {
          case 0:
          // Redirection vers Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DashboardPage(),
              ),
            );
            break;

          case 1:
          // Redirection vers DepensesPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const DepensesPage(),

              ),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Dépenses",
        ),
      ],
    );
  }
}