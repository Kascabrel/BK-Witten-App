import 'package:flutter/material.dart';
import '../../widgets/iconLabelButton.dart';

class HomepageContent extends StatelessWidget {
  const HomepageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        // Taille des boutons (responsive desktop/mobile)
        double iconSize = maxWidth > 800 ? 80 : 60;

        return SizedBox(
          height: maxHeight,
          width: double.infinity,
          child: Stack(
            children: [
              // Image en fond
              Positioned.fill(
                child: Image.asset(
                  "assets/images/homeImg.png",
                  fit: BoxFit.cover,
                ),
              ),

              // Demi-haut : titre centré
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: maxHeight * 0.5,
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.3), // léger overlay
                  child: Text(
                    "Berufskolleg Witten",
                    style: TextStyle(
                      fontSize: maxWidth > 800 ? 48 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Demi-bas : boutons
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: maxHeight * 0.5,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        IconLabelButton(
                          icon: Icons.calendar_today,
                          label: 'Studentplan',
                          onTap: () => Navigator.pushNamed(context, '/studentPlan'),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
