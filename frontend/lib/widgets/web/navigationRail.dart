import 'package:flutter/material.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<NavigationRailDestination> destinationList = [
      const NavigationRailDestination(
          icon: Icon(Icons.school), label: Text("Untis")),
      const NavigationRailDestination(
        icon: Icon(Icons.map),
        label: Text("Pläne"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.event),
        label: Text("Info"),
      ),
      const NavigationRailDestination(
          icon: Icon(Icons.group), label: Text("Personen")),
    ];
    return NavigationRail(
      minWidth: 120,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinationList,
      backgroundColor: Theme
          .of(context)
          .bottomNavigationBarTheme
          .backgroundColor,
      selectedIconTheme: IconThemeData(
        color: Theme
            .of(context)
            .bottomNavigationBarTheme
            .selectedItemColor,
        size: 28,
      ),
      unselectedIconTheme: IconThemeData(
        color: Theme
            .of(context)
            .bottomNavigationBarTheme
            .unselectedItemColor,
        size: 24,
      ),
      selectedLabelTextStyle: TextStyle(
        color: Theme
            .of(context)
            .bottomNavigationBarTheme
            .selectedItemColor,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: Theme
            .of(context)
            .bottomNavigationBarTheme
            .unselectedItemColor,
      ),
    );
  }
}
