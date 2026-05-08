import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'surface_card.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_styles.dart';

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

class CalendarCard extends StatefulWidget {
  const CalendarCard({super.key});

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

  List<Map<String, String>> _eventsFor(DateTime day) {
    final n = _norm(day);
    for (final k in PlannerMockData.scheduledMovies.keys) {
      if (_norm(k) == n) return PlannerMockData.scheduledMovies[k]!;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null ? _eventsFor(_selectedDay!) : <Map<String, String>>[];

    return SurfaceCard(
      headerLeft: Expanded(
        child: Row(
          children: [
            _CircleNavBtn(icon: Icons.chevron_left, onTap: () => setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            })),
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: AppStyles.heading(size: 14),
                textAlign: TextAlign.center,
              ),
            ),
            _CircleNavBtn(icon: Icons.chevron_right, onTap: () => setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            })),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerVisible: false,
            selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
            eventLoader: _eventsFor,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: (sel, foc) => setState(() {
              _selectedDay = sel;
              _focusedDay = foc;
            }),
            onPageChanged: (foc) => setState(() => _focusedDay = foc),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
              weekdayStyle: AppStyles.body(size: 11, color: AppColors.textMuted),
              weekendStyle: AppStyles.body(size: 11, color: AppColors.textMuted),
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              weekendTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              outsideTextStyle: TextStyle(color: Color(0xFF3A3A5A), fontSize: 12),
              todayDecoration: BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
              todayTextStyle: TextStyle(color: AppColors.softPeriwinkle, fontWeight: FontWeight.bold, fontSize: 12),
              markersMaxCount: 0,
            ),
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (ctx, date, _) => Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.softPeriwinkle, width: 1.5),
                ),
                child: Text('${date.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              defaultBuilder: (ctx, date, _) {
                if (_eventsFor(date).isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.successGreenDim, borderRadius: BorderRadius.circular(8)),
                    child: Text('${date.day}', style: const TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.dividerSubtle, height: 1),
          const SizedBox(height: 14),
          Text('UPCOMING', style: AppStyles.label()),
          const SizedBox(height: 10),
          if (selectedEvents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.plannerSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(children: [
                const Icon(Icons.event_busy_rounded, color: AppColors.textMuted, size: 28),
                const SizedBox(height: 8),
                Text('No movies on this day.', style: AppStyles.body(size: 12)),
              ]),
            )
          else
            ...selectedEvents.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.plannerSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${DateFormat('E MMM d').format(_selectedDay!)} — ${e['title']}', style: AppStyles.heading(size: 12)),
                        const SizedBox(height: 2),
                        Text('${e['time']} · ${e['platform']}', style: AppStyles.body(size: 11)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 13),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

class _CircleNavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleNavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(color: AppColors.dividerSubtle, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.white, size: 15),
        ),
      ),
    );
  }
}