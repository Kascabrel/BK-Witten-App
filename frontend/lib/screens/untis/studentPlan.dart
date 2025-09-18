import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentplanPage extends StatefulWidget {
  const StudentplanPage({super.key});

  @override
  State<StudentplanPage> createState() => _StudentplanPageState();
}

class _StudentplanPageState extends State<StudentplanPage> {
  List<String> days = [];
  Map<String, List<dynamic>> lessonsByDay = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final String response =
        await rootBundle.loadString('assets/studentPlan.json');
    final data = json.decode(response);

    setState(() {
      days = List<String>.from(data["days"]);

      // Regrouper les cours par jour
      lessonsByDay = {for (var d in days) d: []};
      for (var lesson in data["lessons"]) {
        lessonsByDay[lesson["day"]]?.add(lesson);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Détection du thème actuel
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Définition des couleurs dynamiques
    final headerColor =
        isDark ? Colors.blueGrey.shade700 : Colors.blue.shade100;
    final cardColor = isDark ? Colors.grey.shade800 : Colors.blue.shade50;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(title: const Text("Studentplan")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;

          if (days.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: isWide ? constraints.maxWidth : 900,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: days.map((day) {
                  final lessons = lessonsByDay[day] ?? [];

                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: headerColor,
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ...lessons.map((lesson) {
                          return Card(
                            margin: const EdgeInsets.all(6),
                            color: cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${lesson['subject']} (${lesson['teacher']})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Raum: ${lesson['room']}",
                                      style: TextStyle(color: textColor)),
                                  Text("${lesson['start']} - ${lesson['end']}",
                                      style: TextStyle(color: textColor)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
