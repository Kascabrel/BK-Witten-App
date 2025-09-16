import 'package:flutter/material.dart';
import 'package:frontend/screens/untis/homePageContent.dart';
import 'package:frontend/widgets/mobil/custumAppBar.dart';
import 'package:frontend/services/update_checker.dart';
import 'package:frontend/widgets/mobil/navigationBar.dart';

import 'customDrawer.dart';
import '../widgets/web/navigationRail.dart'; // Update service

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // for the navigation bar

  final List<Widget> listView = [
    const HomepageContent(),
    const Center(
      child: Text("Inhalt im Entwicklungsprozes"),
    ),
    const Center(
      child: Text("Inhalt im Entwicklungsprozes"),
    ),
    const Center(
      child: Text("Inhalt im Entwicklungsprozes"),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
