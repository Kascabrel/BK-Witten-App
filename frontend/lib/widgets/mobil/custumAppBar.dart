import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.leading,
      this.backgroundColor,
      this.centerTitle = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor, // dynamic
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      //  dynamic
      elevation: 8,
      leading: leading,
      actions: [
        IconButton(
          icon: Icon(
            Icons.person_2_rounded,
            color: Theme.of(context).appBarTheme.foregroundColor, //  dynamic
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // open the drawer
          },
        ),
      ],
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
