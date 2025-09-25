import 'package:flutter/material.dart';

class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;

  const IconLabelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 60, //
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backgroundColor =
        isDark ? theme.colorScheme.primaryContainer : theme.colorScheme.primary;
    final Color iconColor = isDark
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onPrimary;
    final Color textColor = isDark
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onPrimary; 
    //final Color textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;


    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: size * 0.2, // texte proportionnel
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
