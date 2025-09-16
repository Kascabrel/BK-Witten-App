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
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinationList,
      backgroundColor: Colors.blue,
      selectedIconTheme: const IconThemeData(color: Colors.white, size: 28),
      unselectedIconTheme: const IconThemeData(color: Colors.white60, size: 24),
      selectedLabelTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Colors.white60,
      ),
    );
  }
}
