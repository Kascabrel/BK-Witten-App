import 'package:flutter/material.dart';
import 'package:frontend/screens/personenPage.dart';
import 'package:frontend/screens/plan/shoolbuildingPlan.dart';
import 'package:frontend/screens/plan/parkingplan.dart';
import 'package:frontend/screens/untis/studentPlan.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/mitteilungen/mitteilungen_screen.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/homePage.dart';

/// Application entry point.
///
/// Wraps the entire app with [MultiProvider] in order to
/// provide access to [ThemeProvider] and [AuthProvider] across the widget tree.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

/// Root widget of the application.
///
/// Responsible for:
/// - Listening to theme changes via [ThemeProvider]
/// - Listening to auth state via [AuthProvider] to redirect to login
/// - Configuring light and dark themes
/// - Defining named routes
/// - Setting the initial home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

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

          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade900,
            secondary: Colors.blueAccent,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black87,
          ),

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

        /// -------------------------
        /// DARK THEME CONFIGURATION
        /// -------------------------
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade900,

          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade400,
            secondary: Colors.amber,
            surface: Colors.grey.shade800,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white70,
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

        /// Show login screen when not authenticated, home page otherwise.
        home: auth.isLoggedIn ? const MyHomePage() : const LoginScreen(),

        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MyHomePage(),
          '/studentPlan': (context) => const StudentplanPage(),
          '/schoolBuildingPlan': (context) => const SchoolBuildingPlanPage(),
          '/parkingPlan': (context) => const ParkingPlanPage(),
          '/personen': (context) => const PersonenPage(),
          '/mitteilungen': (context) => const MitteilungenScreen(),
        });
  }
}