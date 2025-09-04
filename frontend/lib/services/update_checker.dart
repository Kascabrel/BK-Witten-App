import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  final String currentVersion = "1.0.0"; // the current version of the app

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("https://bk-witten-app.kascali.de/versioning/update.json"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data["version"];
        String apkUrl = data["url"];

        if (latestVersion != currentVersion) {
          _showUpdateDialog(context, apkUrl, latestVersion);
        }
      }
    } catch (e) {
      print("Error when locking for update: $e");
    }
  }

  void _showUpdateDialog(BuildContext context, String apkUrl, String version) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update verfügbar"),
        content: Text("Eine neue version der App ($version) ist verfügbar."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              launchUrl(Uri.parse(apkUrl));
            },
            child: const Text("Download update"),
          ),
        ],
      ),
    );
  }
}
