import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: backgroundColor,
      elevation: 8,
      //shape: const RoundedRectangleBorder(
      //borderRadius: BorderRadius.vertical(
      //  bottom: Radius.circular(20),
      //)
      // ),
      actions: actions,
    );
  }

  // 👇 Obligatoire pour AppBar dans un Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
