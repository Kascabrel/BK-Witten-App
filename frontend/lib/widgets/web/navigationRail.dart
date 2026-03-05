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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.blueGrey.shade900 : Colors.white;
    final selectedColor = isDark ? Colors.amber : Colors.blue.shade900;
    final unselectedColor = isDark ? Colors.white70 : Colors.black87;
    final hoverColor = isDark
        ? Colors.amber.withOpacity(0.2)
        : Colors.blue.shade200.withOpacity(0.3);

    final destinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.school),
        label: Text("Untis"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.map),
        label: Text("Pläne"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.event),
        label: Text("Info"),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.group),
        label: Text("Personen"),
      ),
    ];

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      backgroundColor: backgroundColor,
      selectedIconTheme: IconThemeData(color: selectedColor, size: 28),
      selectedLabelTextStyle: TextStyle(
        color: selectedColor,
        fontWeight: FontWeight.bold,
      ),
      unselectedIconTheme: IconThemeData(color: unselectedColor, size: 24),
      unselectedLabelTextStyle: TextStyle(color: unselectedColor),

      // ⚡ Important: align destinations at the top
      groupAlignment: -1.0,

      destinations: destinations,
      // optionnel: hover/indicator pour Web
      useIndicator: true,
      indicatorColor: hoverColor,
    );
  }
}