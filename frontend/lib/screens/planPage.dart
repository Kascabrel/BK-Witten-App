import 'package:flutter/material.dart';

class PlanePage extends StatelessWidget {
  const PlanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pläne")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600; // 📐 détection mobile vs web

          Widget buildCard({
            required IconData icon,
            required String title,
            required String subtitle,
            required Color color,
            required VoidCallback onTap,
          }) {
            final cardContent = Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 48, color: color),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );

            // 👉 sur mobile on limite la largeur et on centre
            return isWide
                ? Expanded(child: cardContent)
                : Center(
              child: SizedBox(
                width: 300,
                child: cardContent,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCard(
                  icon: Icons.apartment,
                  title: "Schulgebäudeplan",
                  subtitle: "Zeigt den Plan des Schulgebäudes",
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, "/schoolBuildingPlan"),
                ),
                SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                buildCard(
                  icon: Icons.local_parking,
                  title: "Parkplätze für Schüler",
                  subtitle: "Freie Parkplätze in der Umgebung",
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, "/parkingPlan"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
