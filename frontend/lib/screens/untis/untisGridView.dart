import 'package:flutter/material.dart';

import '../../widgets/iconLabelButton.dart';

class UntisGridView extends StatelessWidget {
  const UntisGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust the number of column according to the width
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 5;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            IconLabelButton(
              icon: Icons.calendar_today,
              label: 'Studentplan',
              onTap: () => Navigator.pushNamed(context, '/studentplan'),
            ),
            IconLabelButton(
              icon: Icons.message,
              label: 'Mitteilungen',
              onTap: () => Navigator.pushNamed(context, '/mitteilungen'),
            ),
            IconLabelButton(
              icon: Icons.event,
              label: 'Termine',
              onTap: () => Navigator.pushNamed(context, '/termine'),
            ),
            IconLabelButton(
              icon: Icons.block,
              label: 'Abwesenheit',
              onTap: () => Navigator.pushNamed(context, '/abwesenheit'),
            ),
          ],
        );
      },
    );
  }
}
