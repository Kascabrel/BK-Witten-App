import 'package:flutter/material.dart';
import 'package:frontend/screens/personenPage.dart';
import 'package:frontend/screens/plan/shoolbuildingPlan.dart';
import 'package:frontend/screens/untis/studentPlan.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/homePage.dart';

/// Application entry point.
///
/// Wraps the entire app with [ChangeNotifierProvider] in order to
/// provide access to the [ThemeProvider] across the widget tree.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

/// Root widget of the application.
///
/// Responsible for:
/// - Listening to theme changes via [ThemeProvider]
/// - Configuring light and dark themes
/// - Defining named routes
/// - Setting the initial home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Access the current theme mode (light/dark/system)
    /// from the global ThemeProvider.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
        title: 'BK-Witten-G3',
        debugShowCheckedModeBanner: false,

        /// Dynamically switches between light and dark mode
        /// depending on the value stored in ThemeProvider.
        themeMode: themeProvider.themeMode,

        /// -------------------------
        /// LIGHT THEME CONFIGURATION
        /// -------------------------
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,

          /// Defines the global color palette for light mode.
          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade900,
            secondary: Colors.blueAccent,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black87,
          ),

          /// AppBar styling for light theme.
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          /// Bottom navigation bar styling for light theme.
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue.shade900,
            unselectedItemColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            elevation: 4,
          ),

          /// Default text styles used across the application.
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87),
            bodyLarge:
            TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),

          /// Default card styling (used in lists, dashboards, etc.).
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        /// -------------------------
        /// DARK THEME CONFIGURATION
        /// -------------------------
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade900,

          /// Defines the global color palette for dark mode.
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade400,
            secondary: Colors.amber,
            surface: Colors.grey.shade800,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white70,
          ),

          /// AppBar styling for dark theme.
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          /// Bottom navigation bar styling for dark theme.
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blueGrey.shade900,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            elevation: 4,
          ),

          /// Default text styles used across the application.
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white70),
            bodyLarge:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),

          /// Default card styling for dark mode.
          cardTheme: CardTheme(
            color: Colors.grey.shade800,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        /// Initial screen displayed when the app starts.
        home: const MyHomePage(),

        /// Named routes used for navigation inside the app.
        ///
        /// Allows navigation using:
        /// Navigator.pushNamed(context, '/routeName');
        routes: {
          '/studentPlan': (context) => const StudentplanPage(),
          '/schoolBuildingPlan': (context) => const SchoolBuildingPlanPage(),
          '/personen': (context) => const PersonenPage(),
          // '/parkingPlan': (context) => const ParkingPlanPage(),
        });
  }
}