import 'package:flutter/material.dart';
import 'package:frontend/screens/plan/shoolbuildingPlan.dart';
import 'package:frontend/screens/untis/studentPlan.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/homePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
        title: 'BK-Witten-G3',
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        //  dynamic
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade900,
            secondary: Colors.blueAccent,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black87,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade900, //
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue.shade900,
            unselectedItemColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            elevation: 4,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87),
            bodyLarge:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade900,
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade400,
            secondary: Colors.amber,
            surface: Colors.grey.shade800,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white70, //
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blueGrey.shade900,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            elevation: 4,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white70),
            bodyLarge:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          cardTheme: CardTheme(
            color: Colors.grey.shade800,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        home: const MyHomePage(),
        routes: {
          '/studentPlan': (context) => const StudentplanPage(),
          '/schoolBuildingPlan': (context) => const SchoolBuildingPlanPage(),
          //'/parkingPlan': (context) => const ParkingPlanPage(),
        });
  }
}
