import 'package:flutter/material.dart';
import 'package:frontend/widgets/custum_app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Berufskolleg-Witten"),
      body: const Center(),
    );
  }
}
