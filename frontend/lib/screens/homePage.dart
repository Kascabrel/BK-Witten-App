import 'package:flutter/material.dart';
import 'package:frontend/widgets/custum_app_bar.dart';
import 'package:frontend/services/update_checker.dart'; // Update service

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker().checkForUpdate(context);
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(title: "Berufskolleg-Witten-G3"),
    body: Center(
      child: Text("Inhalt im Entwicklungsprozess"),
    ),
  );
}

}
