import 'package:flutter/material.dart';

/// Model representing a school contact person.
class ContactPerson {
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final IconData icon;
  final Color color;
  final String description;

  const ContactPerson({
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.phone,
    required this.icon,
    required this.color,
    required this.description,
  });
}

/// Page displaying school contact persons grouped by category.

class PersonenPage extends StatefulWidget {
  const PersonenPage({super.key});

  @override
  State<PersonenPage> createState() => _PersonenPageState();
}

class _PersonenPageState extends State<PersonenPage> {
  String _searchQuery = '';
  String _selectedFilter = 'Alle';

  /// Dummy contact data grouped by role category.
  static const List<ContactPerson> _contacts = [
    // --- Schulleitung ---
    ContactPerson(
      name: "Dr. Klaus Hoffmann",
      role: "Schulleiter",
      department: "Schulleitung",
      email: "k.hoffmann@bk-witten.de",
      phone: "02302 / 916-100",
      icon: Icons.school,
      color: Colors.blue,
      description:
      "Verantwortlich für die gesamte Schulorganisation und strategische Ausrichtung der Schule.",
    ),
    ContactPerson(
      name: "Sabine Mertens",
      role: "Stellv. Schulleiterin",
      department: "Schulleitung",
      email: "s.mertens@bk-witten.de",
      phone: "02302 / 916-101",
      icon: Icons.school,
      color: Colors.blue,
      description:
      "Vertretung des Schulleiters, Koordination der Abteilungen und Stundenplanung.",
    ),

    // --- Sekretariat ---
    ContactPerson(
      name: "Monika Schäfer",
      role: "Sekretärin",
      department: "Sekretariat",
      email: "sekretariat@bk-witten.de",
      phone: "02302 / 916-0",
      icon: Icons.badge,
      color: Colors.teal,
      description:
      "Erste Anlaufstelle für allgemeine Anfragen, An- und Abmeldungen sowie Bescheinigungen.",
    ),
    ContactPerson(
      name: "Thomas Bergmann",
      role: "Verwaltung",
      department: "Sekretariat",
      email: "t.bergmann@bk-witten.de",
      phone: "02302 / 916-102",
      icon: Icons.badge,
      color: Colors.teal,
      description:
      "Zuständig für Haushalts- und Personalverwaltung sowie offizielle Dokumentation.",
    ),

    // --- Beratung & Soziales ---
    ContactPerson(
      name: "Laura Zimmermann",
      role: "Schulsozialarbeiterin",
      department: "Beratung & Soziales",
      email: "l.zimmermann@bk-witten.de",
      phone: "02302 / 916-210",
      icon: Icons.favorite,
      color: Colors.pink,
      description:
      "Unterstützung bei persönlichen und sozialen Problemen, Konfliktmediation und Krisenintervention.",
    ),
    ContactPerson(
      name: "Markus Lehmann",
      role: "Berufsberater",
      department: "Beratung & Soziales",
      email: "m.lehmann@bk-witten.de",
      phone: "02302 / 916-211",
      icon: Icons.work,
      color: Colors.orange,
      description:
      "Beratung bei Berufsorientierung, Praktikumsvermittlung und Ausbildungssuche.",
    ),
    ContactPerson(
      name: "Anke Bauer",
      role: "Vertrauenslehrerin",
      department: "Beratung & Soziales",
      email: "a.bauer@bk-witten.de",
      phone: "02302 / 916-212",
      icon: Icons.support_agent,
      color: Colors.purple,
      description:
      "Vertrauensperson für Schülerinnen und Schüler bei persönlichen Anliegen und Konflikten mit Lehrkräften.",
    ),

    // --- Fachbetreuer ---
    ContactPerson(
      name: "Peter Schulze",
      role: "Fachbetreuer Informatik",
      department: "Fachbetreuer",
      email: "p.schulze@bk-witten.de",
      phone: "02302 / 916-301",
      icon: Icons.computer,
      color: Colors.indigo,
      description:
      "Koordination des IT-Unterrichts, Betreuung der EDV-Räume und Ansprechpartner für technische Probleme.",
    ),
    ContactPerson(
      name: "Ingrid Wolff",
      role: "Fachbetreuerin Mathematik",
      department: "Fachbetreuer",
      email: "i.wolff@bk-witten.de",
      phone: "02302 / 916-302",
      icon: Icons.calculate,
      color: Colors.deepOrange,
      description:
      "Koordination des Mathematikunterrichts über alle Bildungsgänge und Förderangebote.",
    ),
    ContactPerson(
      name: "Rainer Koch",
      role: "Fachbetreuer Sport",
      department: "Fachbetreuer",
      email: "r.koch@bk-witten.de",
      phone: "02302 / 916-303",
      icon: Icons.sports_soccer,
      color: Colors.green,
      description:
      "Verantwortlich für den Sportunterricht, Nutzung der Sporthalle und Schulveranstaltungen.",
    ),

    // --- Technischer Dienst ---
    ContactPerson(
      name: "Hans Müller",
      role: "Hausmeister",
      department: "Technischer Dienst",
      email: "h.mueller@bk-witten.de",
      phone: "02302 / 916-400",
      icon: Icons.build,
      color: Colors.brown,
      description:
      "Zuständig für Gebäudepflege, kleinere Reparaturen und die Schlüsselverwaltung.",
    ),
    ContactPerson(
      name: "Stefan Krause",
      role: "IT-Techniker",
      department: "Technischer Dienst",
      email: "s.krause@bk-witten.de",
      phone: "02302 / 916-401",
      icon: Icons.settings,
      color: Colors.blueGrey,
      description:
      "Wartung und Betreuung der schulischen IT-Infrastruktur, Netzwerk und Hardware.",
    ),
  ];

  List<String> get _filterOptions {
    final departments = _contacts.map((c) => c.department).toSet().toList();
    departments.insert(0, 'Alle');
    return departments;
  }

  List<ContactPerson> get _filtered {
    return _contacts.where((c) {
      final matchSearch = _searchQuery.isEmpty ||
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.role.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.department.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter =
          _selectedFilter == 'Alle' || c.department == _selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  Map<String, List<ContactPerson>> get _grouped {
    final Map<String, List<ContactPerson>> map = {};
    for (final c in _filtered) {
      map.putIfAbsent(c.department, () => []).add(c);
    }
    return map;
  }

  void _showContactDetail(ContactPerson person) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Avatar + name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: person.color.withOpacity(0.15),
                      child: Icon(person.icon, color: person.color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            person.role,
                            style: TextStyle(
                              fontSize: 14,
                              color: person.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            person.department,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                // Description
                Text(
                  "Zuständigkeit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  person.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Contact info
                _contactTile(Icons.email, person.email, isDark),
                const SizedBox(height: 8),
                _contactTile(Icons.phone, person.phone, isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactTile(IconData icon, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18, color: isDark ? Colors.white54 : Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = _grouped;

    return Scaffold(
      appBar: AppBar(title: const Text("Personen & Kontakte")),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: "Name, Rolle oder Abteilung suchen...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filterOptions.length,
              itemBuilder: (_, i) {
                final opt = _filterOptions[i];
                final selected = _selectedFilter == opt;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(opt),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedFilter = opt),
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),

          // Contact list
          Expanded(
            child: grouped.isEmpty
                ? const Center(
              child: Text("Keine Personen gefunden."),
            )
                : ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Department header
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: isDark
                              ? Colors.white54
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    // Cards
                    ...entry.value.map((person) {
                      return Card(
                        margin:
                        const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius.circular(12),
                          onTap: () =>
                              _showContactDetail(person),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: person.color
                                      .withOpacity(0.15),
                                  child: Icon(person.icon,
                                      color: person.color,
                                      size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        person.name,
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        person.role,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: person.color,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
