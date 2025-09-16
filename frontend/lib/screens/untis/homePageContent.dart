import 'package:flutter/material.dart';
import '../../widgets/iconLabelButton.dart';

class HomepageContent extends StatelessWidget {
  const HomepageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: largeur totale
        double maxWidth = constraints.maxWidth;

        // Taille de l’image (50% de l’écran en hauteur par ex.)
        double imageHeight = constraints.maxHeight * 0.5;

        // Taille des boutons : plus grands sur desktop
        double iconSize = maxWidth > 800 ? 80 : 60;

        return Column(
          children: [
            // Partie image
            Container(
              height: imageHeight,
              width: double.infinity,
              color: Colors.blue.shade700,
              alignment: Alignment.center,
              child: const Text(
                "Ein Bild",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Partie boutons
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade900, // fond sombre
                child: Center(
                  child: Wrap(
                    spacing: 40,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      IconLabelButton(
                        icon: Icons.calendar_today,
                        label: 'Studentplan',
                        onTap: () => Navigator.pushNamed(context, '/studentplan'),
                        size: iconSize,
                      ),
                      IconLabelButton(
                        icon: Icons.message,
                        label: 'Mitteilungen',
                        onTap: () => Navigator.pushNamed(context, '/mitteilungen'),
                        size: iconSize,
                      ),
                      IconLabelButton(
                        icon: Icons.event,
                        label: 'Termine',
                        onTap: () => Navigator.pushNamed(context, '/termine'),
                        size: iconSize,
                      ),
                      IconLabelButton(
                        icon: Icons.block,
                        label: 'Abwesenheit',
                        onTap: () => Navigator.pushNamed(context, '/abwesenheit'),
                        size: iconSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
