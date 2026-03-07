import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

/// Application drawer displayed from the right side.
///
/// Provides:
/// - User information header (name from WebUntis session)
/// - Settings and logout actions
/// - Theme switch (light/dark mode)
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final displayName = auth.displayName ?? 'Gast';
    final username = auth.username ?? '';

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(displayName),
            accountEmail: Text(username),
            currentAccountPicture: const CircleAvatar(
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

          /// Logout — clears the JWT token and navigates to the login screen.
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Abmelden"),
            onTap: () async {
              Navigator.pop(context);
              await auth.logout();
            },
          ),

          const Divider(),

          /// Switch to toggle between light and dark mode.
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