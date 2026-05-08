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

  int getTotalNightsPlanned() => _eventsBox.length;

  int getTotalRuntimeMinutes() {
    return _eventsBox.values.fold(0, (sum, event) => sum + event.runtime);
  }

  double getAverageRating() {
    final ratedEvents = _eventsBox.values.where((e) => e.isReviewed && e.rating != null);
    if (ratedEvents.isEmpty) return 0.0;
    final sum = ratedEvents.fold(0.0, (s, e) => s + e.rating!);
    return sum / ratedEvents.length;
  }

  int getPendingReviewCount() {
    return _eventsBox.values.where((e) => e.isWatched && !e.isReviewed).length;
  }

  List<MapEntry<String, double>> getTopGenresWithPercentages([int limit = 3]) {
    final counts = <String, int>{};
    int total = 0;
    for (final e in _eventsBox.values) {
      for (final g in e.genres) {
        counts[g] = (counts[g] ?? 0) + 1;
        total++;
      }
    }
    if (total == 0) return [];
    
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => MapEntry(e.key, (e.value / total) * 100)).toList();
  }

  List<MapEntry<String, double>> getTopPlatformsWithPercentages([int limit = 3]) {
    final counts = <String, int>{};
    int total = 0;
    for (final e in _eventsBox.values) {
      counts[e.platform] = (counts[e.platform] ?? 0) + 1;
      total++;
    }
    if (total == 0) return [];
    
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => MapEntry(e.key, (e.value / total) * 100)).toList();
  }
}