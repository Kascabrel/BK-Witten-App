import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Color backgroundColor;
  final bool centerTitle;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.leading,
      this.backgroundColor = Colors.blue,
      this.centerTitle = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 8,
      leading: leading,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_2_rounded, color: Colors.white),
          onPressed: () {
            // ouvre le Drawer de droite
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
