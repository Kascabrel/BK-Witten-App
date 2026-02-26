import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Application drawer displayed from the right side.
///
/// Provides:
/// - User information header
/// - Settings and logout actions
/// - Theme switch (light/dark mode)
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    /// Access the global ThemeProvider to read
    /// and toggle the current theme mode.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Max Mustermann"),
            accountEmail: Text("max@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),

          /// Navigates to settings (currently only closes drawer).
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Einstellungen"),
            onTap: () => Navigator.pop(context),
          ),

          /// Logout action (currently only closes drawer).
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Abmelden"),
            onTap: () => Navigator.pop(context),
          ),

          const Divider(),

          /// Switch to toggle between light and dark mode.
          /// Updates the global theme via ThemeProvider.
          SwitchListTile(
            title: const Text("Dunkelmodus"),
            value: themeProvider.isDarkMode,
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.blue,
            ),
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }
}