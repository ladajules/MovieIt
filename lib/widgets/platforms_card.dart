import 'package:flutter/material.dart';
import 'surface_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';


class PlannerMockData {
  static const int nightsPlanned = 8;
  static const String totalRuntime = '19h';
  static const String avgRating = '4.2';
  static const int pending = 2;
  static const int streakWeeks = 5;
  static const int personalBest = 8;
  static const int monthlyGoalCurrent = 2;
  static const int monthlyGoalTarget = 4;

  static const List<Map<String, String>> genres = [
    {'name': 'Sci-Fi', 'pct': '82'},
    {'name': 'Drama', 'pct': '64'},
    {'name': 'Thriller', 'pct': '41'},
  ];

  static const List<Map<String, String>> platforms = [
    {'name': 'Netflix', 'pct': '58'},
    {'name': 'Prime', 'pct': '27'},
    {'name': 'Local', 'pct': '15'},
  ];

  static const List<Map<String, String>> recentActivity = [
    {'title': 'The Batman', 'date': 'Yesterday', 'rating': '4.0'},
    {'title': 'Poor Things', 'date': 'May 4', 'rating': '4.5'},
    {'title': 'Oppenheimer', 'date': 'May 1', 'rating': '5.0'},
    {'title': 'Arrival', 'date': 'Apr 28', 'rating': '4.2'},
  ];

  static final Map<DateTime, List<Map<String, String>>> scheduledMovies = {
    DateTime.now().add(const Duration(days: 2)): [
      {'title': 'Dune: Part Two', 'platform': 'Netflix', 'time': '8:00 PM'},
    ],
    DateTime.now().add(const Duration(days: 5)): [
      {'title': 'The Batman', 'platform': 'Local File', 'time': '7:30 PM'},
    ],
  };

  static const List<Map<String, dynamic>> watchlist = [
    {'title': 'Blade Runner 2049', 'year': '2017', 'color1': Color(0xFF6B21A8), 'color2': Color(0xFF1E3A5F)},
    {'title': 'Arrival', 'year': '2016', 'color1': Color(0xFF0F4C6B), 'color2': Color(0xFF1A5C4A)},
    {'title': 'Oppenheimer', 'year': '2023', 'color1': Color(0xFF7C3A00), 'color2': Color(0xFF4A1A00)},
    {'title': 'Everything Everywh...', 'year': '2022', 'color1': Color(0xFF8B1A5C), 'color2': Color(0xFF3D0A2E)},
    {'title': 'The Batman', 'year': '2022', 'color1': Color(0xFF1A1A8B), 'color2': Color(0xFF0A0A4A)},
    {'title': 'Poor Things', 'year': '2023', 'color1': Color(0xFF0A5C3A), 'color2': Color(0xFF063D27)},
  ];
}

class PlatformsCard extends StatelessWidget {
  const PlatformsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      headerLeft: Text('Platforms', style: AppStyles.heading(size: 14)),
      body: Column(
        children: PlannerMockData.platforms.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _GenreStackedBar(label: p['name']!, pct: double.parse(p['pct']!)),
        )).toList(),
      ),
    );
  }
}

class _GenreStackedBar extends StatelessWidget {
  final String label;
  final double pct;
  const _GenreStackedBar({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyles.body(size: 13, color: AppColors.white)),
            Text('${pct.toInt()}%', style: AppStyles.body(size: 12)),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(builder: (ctx, c) => Stack(children: [
          Container(height: 7, decoration: BoxDecoration(color: AppColors.dividerSubtle, borderRadius: BorderRadius.circular(4))),
          Container(height: 7, width: c.maxWidth * (pct / 100), decoration: BoxDecoration(color: AppColors.softPeriwinkle, borderRadius: BorderRadius.circular(4))),
        ])),
      ],
    );
  }
}