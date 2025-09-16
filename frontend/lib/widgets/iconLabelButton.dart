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
    this.size = 60, // défaut pour mobile
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

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
              color: primaryColor,
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: size * 0.2, // texte proportionnel
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
