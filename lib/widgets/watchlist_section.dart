import 'package:flutter/material.dart';

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

class WatchlistSection extends StatelessWidget {
  const WatchlistSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Watchlist', style: AppStyles.heading(size: 16)),
            _PillButton(label: '+ Add', onTap: () {}),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (ctx, c) {
          final cols = c.maxWidth > 500 ? 4 : 2;
          final movies = PlannerMockData.watchlist;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: movies.map((m) {
              final w = (c.maxWidth - (cols - 1) * 12) / cols;
              return _WatchlistCard(movie: m, width: w);
            }).toList(),
          );
        }),
      ],
    );
  }
}

class _WatchlistCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final double width;
  const _WatchlistCard({required this.movie, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: width * 1.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [movie['color1'] as Color, movie['color2'] as Color]),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 7),
        Text(movie['title'] as String, style: AppStyles.body(size: 12, color: AppColors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(movie['year'] as String, style: AppStyles.body(size: 11)),
      ]),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.plannerSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Text(label, style: AppStyles.body(size: 12, color: AppColors.white)),
        ),
      ),
    );
  }
}