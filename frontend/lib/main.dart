import 'package:flutter/material.dart';
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
            // ✅ bleu foncé corporate
            secondary: Colors.blueAccent,
            // ✅ accent clair pour feedback
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black87,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade900, // ✅ bleu foncé
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
            // ✅ fond blanc
            selectedItemColor: Colors.blue.shade900,
            // ✅ sélection bleu foncé
            unselectedItemColor: Colors.black87,
            // ✅ icônes non sélectionnées en noir/gris
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
          primaryColor: Colors.blue.shade400,
          scaffoldBackgroundColor: Colors.grey.shade900,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blueGrey.shade900,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white60,
          ),
        ),
        home: const MyHomePage(),
        routes: {
          '/studentPlan': (context) => const StudentplanPage(),
        });
  }
}
