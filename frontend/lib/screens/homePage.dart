import 'package:flutter/material.dart';
import 'package:frontend/widgets/custum_app_bar.dart';
import 'package:frontend/services/update_checker.dart';
import 'package:frontend/widgets/navigation_bar.dart';

import '../widgets/navigation_rail.dart'; // Update service

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
          appBar: const CustomAppBar(title: "Berufskolleg-Witten-G3"),
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
          drawer:Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("Menu", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text("Untis"),
                  onTap: () {
                    Navigator.pop(context); // fermer le drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text("Pläne"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
