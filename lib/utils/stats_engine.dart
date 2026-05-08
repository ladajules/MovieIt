import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheduled_event.dart';

class StatsEngine {
  final Box<ScheduledEvent> _eventsBox;
  
  StatsEngine(this._eventsBox);

  int getCurrentMonthProgress() {
    final now = DateTime.now();
    return _eventsBox.values.where((e) {
      return e.scheduledDate.year == now.year &&
             e.scheduledDate.month == now.month &&
             e.isWatched == true;
    }).length;
  }

  int getWeeklyStreak() {
    final now = DateTime.now();
    final pastEvents = _eventsBox.values.where((e) => e.isWatched == true);
    if (pastEvents.isEmpty) return 0;

    final activeWeeks = pastEvents.map((e) => _startOfWeek(e.scheduledDate)).toSet().toList();
    activeWeeks.sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkWeek = _startOfWeek(now);

    if (!activeWeeks.contains(checkWeek)) {
      checkWeek = checkWeek.subtract(const Duration(days: 7));
    }

    for (final week in activeWeeks) {
      if (week.isAtSameMomentAs(checkWeek)) {
        streak++;
        checkWeek = checkWeek.subtract(const Duration(days: 7));
      } else if (week.isBefore(checkWeek)) {
        break; 
      }
    }
    return streak;
  }

  DateTime _startOfWeek(DateTime date) {
    final daysToSubtract = date.weekday - 1; 
    final monday = date.subtract(Duration(days: daysToSubtract));
    return DateTime(monday.year, monday.month, monday.day);
  }
}