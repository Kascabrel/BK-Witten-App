import 'package:flutter/material.dart';
import 'package:frontend/widgets/mobil/custum_app_bar.dart';
import 'package:frontend/services/update_checker.dart';
import 'package:frontend/widgets/mobil/navigation_bar.dart';

import 'customDrawer.dart';
import '../widgets/web/navigation_rail.dart'; // Update service

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // for the navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        print("the first item was clicked");
        break;
      case 1:
        print("the second item was clicked");
        break;
      case 3:
        print("the third item was clicked");
        break;
      case 4:
        print("the fourth item was clicked");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker().checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800; // seuil responsive

        return Scaffold(
          appBar: CustomAppBar(
            title: isDesktop
                ? "Berufskolleg-Witten des Enepe-Ruhr-Kreises"
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
              const Expanded(
                child: Center(
                  child: Text("Inhalt im Entwicklungsprozess"),
                ),
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
