import 'package:flutter/material.dart';
import 'package:frontend/widgets/custum_app_bar.dart';
import 'package:frontend/services/update_checker.dart'; // Update service

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String?> _latestVersionFuture;

  @override
  void initState() {
    super.initState();
    _latestVersionFuture = UpdateChecker.getLastVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker().checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Berufskolleg-Witten-G3"),
      body: Center(
        child: FutureBuilder<String?>(
          future: _latestVersionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); //
            } else if (snapshot.hasError) {
              return const Text("Fehler beim Laden der Version.");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Text("Letzte verfügbare Version: ${snapshot.data}");
            } else {
              return const Text("Keine Versionsinformation verfügbar.");
            }
          },
        ),
      ),
    );
  }
}
