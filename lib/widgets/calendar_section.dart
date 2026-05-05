import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'two_tone_card.dart'; 

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // mock (TO DELETE)
  final Map<DateTime, List<Map<String, String>>> _scheduledMovies = {
    DateTime.now().add(const Duration(days: 2)): [
      {'title': 'Dune: Part Two', 'platform': 'Netflix', 'time': 'In 2 days'}
    ],
    DateTime.now().add(const Duration(days: 5)): [
      {'title': 'The Batman', 'platform': 'Local File', 'time': 'In 5 days'},
      {'title': 'Interstellar', 'platform': 'Prime', 'time': 'In 5 days'}
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    for (var key in _scheduledMovies.keys) {
      if (_normalizeDate(key) == normalizedDay) {
        return _scheduledMovies[key]!;
      }
    }
    return [];
  }

  void _onLeftChevronTapped() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
    });
  }

  void _onRightChevronTapped() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthYearText = DateFormat('MMMM yyyy').format(_focusedDay);
    final selectedEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    
    int nightsPlannedThisMonth = 0;
    _scheduledMovies.forEach((date, movies) {
      if (date.month == _focusedDay.month && date.year == _focusedDay.year) {
        nightsPlannedThisMonth++;
      }
    });

    return TwoToneCard(
      customTitle: Row(
        children: [
          Text(monthYearText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(width: 12),
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _onLeftChevronTapped,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _onRightChevronTapped,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      trailing: "$nightsPlannedThisMonth nights planned",
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; 
              });
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white54, fontSize: 12),
              weekendStyle: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              outsideTextStyle: TextStyle(color: Colors.white24),
              todayDecoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color(0xFF1D2440), borderRadius: BorderRadius.circular(8)),
                  child: Text('${date.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                );
              },
              defaultBuilder: (context, date, focusedDay) {
                final dayEvents = _getEventsForDay(date);

                if (dayEvents.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                    child: Text('${date.day}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  );
                }
                return null;
              },
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 10,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00BFA5)),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          
          const SizedBox(height: 24),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          
          const Text("UPCOMING", style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          
          if (selectedEvents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Icon(Icons.event_busy_rounded, color: Colors.white.withOpacity(0.2), size: 36),
                  const SizedBox(height: 12),
                  const Text("No movies added to calendar.", style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            )
          else
            ...selectedEvents.map((event) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat('E MMM d').format(_selectedDay!)} — ${event['title']}", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                      const SizedBox(height: 4),
                      Text("${event['time']} - ${event['platform']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }
}