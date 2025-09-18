import 'package:flutter/material.dart';

class SchoolBuildingPlanPage extends StatelessWidget {
  const SchoolBuildingPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> buildings = {
      "A-Gebäude": {
        "color": Colors.red,
        "desc": "Hauptgebäude mit Schulleitung und Lehrerzimmer. "
            "Auch hier befindet sich das Sekretariat."
      },
      "B-Gebäude": {
        "color": Colors.orange,
        "desc": "Klassenzimmer und Unterrichtsräume. "
            "Direkt vom Haupteingang erreichbar."
      },
      "C-Gebäude": {
        "color": Colors.blue,
        "desc": "Lernzentrum sowie die Klassenräume 1 und 2. "
            "Hier befinden sich auch einige Fachräume."
      },
      "D-Gebäude": {
        "color": Colors.green,
        "desc": "Zusätzliche Unterrichtsräume. "
            "In unmittelbarer Nähe zu den Toiletten."
      },
      "E-Gebäude": {
        "color": Colors.redAccent,
        "desc": "Separates Gebäude für Fachunterricht und Projekte."
      },
      "Sporthalle": {
        "color": Colors.black,
        "desc":
            "Turnhalle für den Sportunterricht und schulische Veranstaltungen."
      },
    };

    double screenWidth = MediaQuery.of(context).size.width;

    Widget planImage = Card(
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          "assets/images/buildPlan.png",
          fit: BoxFit.contain,
        ),
      ),
    );

    Widget buildingList = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          "Legende & Beschreibung",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...buildings.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: entry.value["color"],
                child: Text(
                  entry.key.substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(entry.value["desc"]),
            ),
          );
        }),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Gebäudeplan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
            child: screenWidth > 800
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: planImage),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: buildingList),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      planImage,
                      buildingList,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
