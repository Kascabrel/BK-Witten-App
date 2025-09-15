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
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.school),
          label: Text("Untis"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.map),
          label: Text("Pläne"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event),
          label: Text("Info"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.group),
          label: Text("Personen"),
        ),
      ],
      backgroundColor: Colors.blue,
    );
  }
}
