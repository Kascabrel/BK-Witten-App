import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Redesigned weekly student timetable page.
///
/// Changes vs original:
/// - Day selector chips instead of a plain horizontal table
/// - One day at a time on mobile, full week on desktop
/// - Lesson cards with colored left border per subject
/// - Time shown as a visual timeline pill
/// - Empty state illustration
class StudentplanPage extends StatefulWidget {
  const StudentplanPage({super.key});

  @override
  State<StudentplanPage> createState() => _StudentplanPageState();
}

class _StudentplanPageState extends State<StudentplanPage>
    with TickerProviderStateMixin {
  List<String> days = [];
  Map<String, List<dynamic>> lessonsByDay = {};
  int _selectedDayIndex = 0;
  late TabController _tabController;
  bool _loading = true;

  /// Persistent color mapping per subject for visual consistency.
  final Map<String, Color> _subjectColors = {};
  final List<Color> _palette = const [
    Color(0xFF4A90E2),
    Color(0xFF50C878),
    Color(0xFFFF7043),
    Color(0xFFAB47BC),
    Color(0xFFFFB300),
    Color(0xFF26C6DA),
    Color(0xFFEF5350),
    Color(0xFF66BB6A),
  ];

  Color _colorForSubject(String subject) {
    return _subjectColors.putIfAbsent(
      subject,
          () => _palette[_subjectColors.length % _palette.length],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final String response =
    await rootBundle.loadString('assets/studentPlan.json');
    final data = json.decode(response);

    final loadedDays = List<String>.from(data["days"]);
    final Map<String, List<dynamic>> grouped = {for (var d in loadedDays) d: []};
    for (var lesson in data["lessons"]) {
      grouped[lesson["day"]]?.add(lesson);
    }

    setState(() {
      days = loadedDays;
      lessonsByDay = grouped;
      _loading = false;
      _tabController.dispose();
      _tabController = TabController(length: days.length, vsync: this);
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() => _selectedDayIndex = _tabController.index);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0F1923) : const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text("Stundenplan"),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F1923) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        bottom: _loading || days.isEmpty
            ? null
            : PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: _DayTabBar(
            days: days,
            controller: _tabController,
            isDark: isDark,
            colorScheme: colorScheme,
          ),
        ),
      ),
      body: _buildBody(context, isDark),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (days.isEmpty) return const Center(child: Text("Keine Daten verfügbar"));

    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return _DesktopWeekView(
        days: days,
        lessonsByDay: lessonsByDay,
        colorForSubject: _colorForSubject,
        isDark: isDark,
      );
    }

    // Mobile: TabBarView needs to expand to fill available space
    return TabBarView(
      controller: _tabController,
      children: days
          .map((day) => _DayColumn(
        lessons: lessonsByDay[day] ?? [],
        colorForSubject: _colorForSubject,
        isDark: isDark,
      ))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Day tab bar
// ─────────────────────────────────────────────────────────────────────────────

class _DayTabBar extends StatelessWidget {
  final List<String> days;
  final TabController controller;
  final bool isDark;
  final ColorScheme colorScheme;

  const _DayTabBar({
    required this.days,
    required this.controller,
    required this.isDark,
    required this.colorScheme,
  });

  String _short(String day) {
    if (day.length >= 2) return day.substring(0, 2).toUpperCase();
    return day.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? const Color(0xFF0F1923) : Colors.white,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding:
        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
        isDark ? Colors.white54 : Colors.black45,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: days
            .map((d) => Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(d),
          ),
        ))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile: single day column
// ─────────────────────────────────────────────────────────────────────────────

class _DayColumn extends StatelessWidget {
  final List<dynamic> lessons;
  final Color Function(String) colorForSubject;
  final bool isDark;

  const _DayColumn({
    required this.lessons,
    required this.colorForSubject,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.weekend_rounded,
                size: 56,
                color: isDark ? Colors.white24 : Colors.black12),
            const SizedBox(height: 12),
            Text(
              "Kein Unterricht",
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: lessons.length,
      itemBuilder: (_, i) => _LessonCard(
        lesson: lessons[i],
        color: colorForSubject(lessons[i]['subject'] ?? ''),
        isDark: isDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop: all days side by side
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopWeekView extends StatelessWidget {
  final List<String> days;
  final Map<String, List<dynamic>> lessonsByDay;
  final Color Function(String) colorForSubject;
  final bool isDark;

  const _DesktopWeekView({
    required this.days,
    required this.lessonsByDay,
    required this.colorForSubject,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Use full width with horizontal margin — no horizontal scroll on wide screens
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double hPadding = totalWidth > 1200 ? 48 : 24;
        final double availableWidth = totalWidth - hPadding * 2;
        final double colWidth = (availableWidth - (days.length - 1) * 12) / days.length;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.fromLTRB(hPadding, 20, hPadding, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Week header row
              Row(
                children: days.map((day) {
                  return SizedBox(
                    width: colWidth,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? Colors.white12
                              : Colors.black.withOpacity(0.07),
                        ),
                        boxShadow: isDark
                            ? []
                            : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Lessons row — each column independent scroll
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: days.map((day) {
                    final lessons = lessonsByDay[day] ?? [];
                    return SizedBox(
                      width: colWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (lessons.isEmpty)
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.03)
                                    : Colors.black.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                "Frei",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black26,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ...lessons.map((lesson) => Padding(
                            padding: const EdgeInsets.only(right: 12, bottom: 10),
                            child: _LessonCard(
                              lesson: lesson,
                              color: colorForSubject(
                                  lesson['subject'] ?? ''),
                              isDark: isDark,
                              compact: false,
                            ),
                          )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Lesson card
// ─────────────────────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final dynamic lesson;
  final Color color;
  final bool isDark;
  final bool compact;

  const _LessonCard({
    required this.lesson,
    required this.color,
    required this.isDark,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Color.alphaBlend(color.withOpacity(0.08), const Color(0xFF1A2535))
        : Color.alphaBlend(color.withOpacity(0.06), Colors.white);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.25 : 0.2),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: compact ? 10 : 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject
                    Text(
                      lesson['subject'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 13 : 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Teacher
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            lesson['teacher'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Time + room: use Wrap so pills never overflow
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Time pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 11, color: color),
                              const SizedBox(width: 4),
                              Text(
                                "${lesson['start']} – ${lesson['end']}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Room pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.07)
                                : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.door_front_door_outlined,
                                  size: 11,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black45),
                              const SizedBox(width: 4),
                              Text(
                                lesson['room'] ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}