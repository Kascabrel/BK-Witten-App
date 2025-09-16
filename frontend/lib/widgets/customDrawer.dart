import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _darkMode = false; // 👈 état local

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Nax Mustermann"),
            accountEmail: Text("max@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          // --- Navigation ---
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Einstellungen"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Abmelden"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // --- Switch dark / light mode ---
          SwitchListTile(
            title: const Text("Dunkelmodus"),
            value: _darkMode,
            secondary: Icon(
              _darkMode ? Icons.dark_mode : Icons.light_mode,
              color: _darkMode ? Colors.amber : Colors.blue,
            ),
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // here modify the themeprovider
            },
          ),
        ],
      ),
    );
  }
}
