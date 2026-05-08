import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/local_db_service.dart';

import '../../widgets/surface_card.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_styles.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: LocalDbService().listenToEvents(),
      builder: (context, box, _) {
        
        final eventMap = <DateTime, List<ScheduledEvent>>{};
        for (final e in box.values) {
          final date = _norm(e.scheduledDate);
          eventMap.putIfAbsent(date, () => []).add(e);
        }

        final selectedEvents = eventMap[_norm(_selectedDay!)] ?? <ScheduledEvent>[];

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
              TableCalendar<ScheduledEvent>(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                headerVisible: false,
                selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                
                eventLoader: (day) => eventMap[_norm(day)] ?? [],
                
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
                  todayDecoration: BoxDecoration(color: Color(0xFF2A1A4A), shape: BoxShape.circle),
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
                    if ((eventMap[_norm(date)] ?? []).isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.successGreenDim,
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                            Text(
                              '${DateFormat('E MMM d').format(_selectedDay!)} — ${e.movieTitle}',
                              style: AppStyles.heading(size: 12),
                            ),
                            const SizedBox(height: 2),

                            Text('${DateFormat('h:mm a').format(e.scheduledDate)} · ${e.platform}', style: AppStyles.body(size: 11)),
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
      },
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