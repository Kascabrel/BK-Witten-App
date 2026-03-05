import 'package:flutter/material.dart';
import 'package:frontend/screens/personenPage.dart';
import 'package:frontend/screens/planPage.dart';
import 'package:frontend/screens/untis/homePageContent.dart';
import 'package:frontend/widgets/mobil/custumAppBar.dart';
import 'package:frontend/services/update_checker.dart';
import 'package:frontend/widgets/mobil/navigationBar.dart';

import 'customDrawer.dart';
import '../widgets/web/navigationRail.dart';

/// Main application home page.
///
/// Handles:
/// - Responsive layout (mobile vs desktop)
/// - Navigation state management
/// - Update check on startup
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Currently selected navigation index.
  int _selectedIndex = 0;

  /// List of pages displayed depending on the selected navigation item.
  final List<Widget> listView = [
    const HomepageContent(),
    const PlanePage(),
    const Center(
      child: Text("Inhalt im Entwicklungsprozes (Informationen)"),
    ),
    const PersonenPage(),
  ];

  /// Updates the selected navigation index and rebuilds the UI.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    /// Triggers an update check after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker().checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        return Scaffold(
          appBar: CustomAppBar(
            title: isDesktop
                ? "Berufskolleg-Witten des Ennepe-Ruhr-Kreises"
                : "Berufskolleg-Witten",
            centerTitle: isDesktop,
          ),
          body: Row(
            children: [
              if (isDesktop)
                CustomNavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                ),
              Expanded(
                child: listView[_selectedIndex],
              ),
            ],
          ),
          bottomNavigationBar: isDesktop
              ? null
              : CustomBottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          endDrawer: const CustomDrawer(),
        );
      },
    );
  }
}
