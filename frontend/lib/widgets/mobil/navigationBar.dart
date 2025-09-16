import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTap});

  final List<BottomNavigationBarItem> navigationItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.school), label: "Untis"),
    const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Pläne"),
    const BottomNavigationBarItem(icon: Icon(Icons.event), label: "info"),
    const BottomNavigationBarItem(icon: Icon(Icons.group), label: "Personen")
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //

    return BottomNavigationBar(
      items: navigationItem,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      showUnselectedLabels: true,
    );
  }
}
