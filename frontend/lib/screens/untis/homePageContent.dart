import 'package:flutter/material.dart';
import '../../widgets/iconLabelButton.dart';

/// Main homepage content — redesigned with a modern, immersive layout.
///
/// Features:
/// - Full-screen background image with layered gradient overlays
/// - Animated school name with subtle letter-spacing
/// - Glass-morphism style shortcut cards at the bottom
/// - Responsive between mobile and desktop
class HomepageContent extends StatefulWidget {
  const HomepageContent({super.key});

  @override
  State<HomepageContent> createState() => _HomepageContentState();
}

class _HomepageContentState extends State<HomepageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mq = MediaQuery.of(context);
    final double screenWidth = mq.size.width;
    final double screenHeight = mq.size.height - mq.padding.top - mq.padding.bottom - kToolbarHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth > 0 ? constraints.maxWidth : screenWidth;
        final double maxHeight = constraints.maxHeight > 0 && constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : screenHeight;
        final bool isDesktop = maxWidth > 800;

        return SizedBox(
          height: maxHeight,
          width: double.infinity,
          child: Stack(
            children: [
              // ─── Background image ───────────────────────────────────
              Positioned.fill(
                child: Image.asset(
                  isDesktop
                      ? "assets/images/home.jpg"
                      : "assets/images/homeImg.png",
                  fit: BoxFit.cover,
                ),
              ),

              // ─── Gradient overlay (top → transparent, bottom → dark) ─
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.10),
                        Colors.black.withOpacity(0.65),
                        Colors.black.withOpacity(0.92),
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),
              ),

              // ─── Hero title block ────────────────────────────────────
              Positioned(
                top: maxHeight * 0.12,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      children: [
                        // Eyebrow label
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "Berufskolleg des Ennepe-Ruhr-Kreises",
                            style: TextStyle(
                              fontSize: isDesktop ? 13 : 11,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 1.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Main title
                        Text(
                          "BK Witten",
                          style: TextStyle(
                            fontSize: isDesktop ? 64 : 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                blurRadius: 24,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Subtitle
                        Text(
                          "Deine Schule. Deine App.",
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 14,
                            color: Colors.white.withOpacity(0.75),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Quick-action cards at the bottom ───────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 40 : 20,
                      24,
                      isDesktop ? 40 : 20,
                      isDesktop ? 36 : 28,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 16),
                          child: Text(
                            "Schnellzugriff",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        isDesktop
                            ? Row(
                          children: _buildActionCards(
                              context, isDesktop, isDark),
                        )
                            : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _buildActionCards(
                              context, isDesktop, isDark),
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

  List<Widget> _buildActionCards(
      BuildContext context, bool isDesktop, bool isDark) {
    final actions = [
      _ActionItem(
        icon: Icons.calendar_today_rounded,
        label: "Stundenplan",
        sublabel: "Wochenpläne",
        color: const Color(0xFF4A90E2),
        route: '/studentPlan',
      ),
      _ActionItem(
        icon: Icons.chat_bubble_outline_rounded,
        label: "Mitteilungen",
        sublabel: "Neuigkeiten",
        color: const Color(0xFF50C878),
        route: '/mitteilungen',
      ),
      _ActionItem(
        icon: Icons.event_rounded,
        label: "Termine",
        sublabel: "Kalender",
        color: const Color(0xFFFF7043),
        route: '/termine',
      ),
    ];

    return actions.map((item) {
      final card = _QuickActionCard(
        item: item,
        isDesktop: isDesktop,
      );
      return isDesktop ? Expanded(child: card) : card;
    }).toList();
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final String route;
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.route,
  });
}

/// Glass-morphism style quick-action card.
class _QuickActionCard extends StatefulWidget {
  final _ActionItem item;
  final bool isDesktop;

  const _QuickActionCard({required this.item, required this.isDesktop});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: widget.isDesktop
              ? const EdgeInsets.symmetric(horizontal: 6)
              : EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          constraints: BoxConstraints(minWidth: 130, maxWidth: widget.isDesktop ? double.infinity : 160),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.22)
                : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? item.color.withOpacity(0.7)
                  : Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: item.color.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      item.sublabel,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ), // end Column
              ), // end Flexible
              if (widget.isDesktop) ...[
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white.withOpacity(0.4),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}