import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheduled_event.dart';
import '../models/user_stats.dart';
import '../models/user_preferences.dart';

class LocalDbService {
  static const String _eventsBoxName = 'scheduledEvents';
  static const String _statsBoxName = 'userStats';
  static const String _prefsBoxName = 'userPreferences';
  static const String _watchlistBoxName = 'watchlistMovieIds';

  // PREFERNCES
  Box<UserPreferences> get _prefsBox => Hive.box<UserPreferences>(_prefsBoxName);

  UserPreferences getPreferences() {
    return _prefsBox.get('main_prefs') ?? UserPreferences();
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await _prefsBox.put('main_prefs', prefs);
  }

  // USER STATS
  Box<UserStats> get _statsBox => Hive.box<UserStats>(_statsBoxName);

  UserStats getStats() {
    return _statsBox.get('main_stats') ?? UserStats();
  }

  Future<void> _saveStats(UserStats stats) async {
    await _statsBox.put('main_stats', stats);
  }

  // SCHEDULED EVENTS
  Box<ScheduledEvent> get _eventsBox => Hive.box<ScheduledEvent>(_eventsBoxName);

  List<ScheduledEvent> getAllEvents() {
    return _eventsBox.values.toList();
  }

  Future<void> scheduleEvent(ScheduledEvent event) async {
    // save  event
    await _eventsBox.put(event.id, event);

    // update stats
    final stats = getStats();
    stats.nightsPlanned += 1;
    stats.totalRuntimeMinutes += event.runtime;
    
    for (String genre in event.genres) {
      stats.genreCounts[genre] = (stats.genreCounts[genre] ?? 0) + 1;
    }
    
    await _saveStats(stats);
  }

  Future<void> updateEventReview(String eventId, double rating, String note) async {
    final event = _eventsBox.get(eventId);
    if (event != null && !event.isReviewed) {
      // update evnet
      event.isReviewed = true;
      event.rating = rating;
      event.note = note;
      await event.save(); 

      // update user stats 
      final stats = getStats();
      stats.totalMoviesRated += 1;
      stats.totalRatingSum += rating;
      await _saveStats(stats);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final event = _eventsBox.get(eventId);
    if (event != null) {
      // rollback stats
      final stats = getStats();
      stats.nightsPlanned = (stats.nightsPlanned - 1).clamp(0, double.infinity).toInt();
      stats.totalRuntimeMinutes = (stats.totalRuntimeMinutes - event.runtime).clamp(0, double.infinity).toInt();
      
      for (String genre in event.genres) {
        if (stats.genreCounts.containsKey(genre)) {
          stats.genreCounts[genre] = (stats.genreCounts[genre]! - 1).clamp(0, double.infinity).toInt();
        }
      }

      if (event.isReviewed && event.rating != null) {
        stats.totalMoviesRated = (stats.totalMoviesRated - 1).clamp(0, double.infinity).toInt();
        stats.totalRatingSum = (stats.totalRatingSum - event.rating!).clamp(0.0, double.infinity).toDouble();
      }

      await _saveStats(stats);
      
      // del event
      await _eventsBox.delete(eventId);
    }
  }

  // WAATCHLIST
  Box<String> get _watchlistBox => Hive.box<String>(_watchlistBoxName);

  List<String> getWatchlistIds() {
    return _watchlistBox.values.toList();
  }

  Future<void> addToWatchlist(String movieId) async {
    if (!_watchlistBox.values.contains(movieId)) {
      await _watchlistBox.add(movieId);
    }
  }

  Future<void> removeFromWatchlist(String movieId) async {
    final key = _watchlistBox.keys.firstWhere(
      (k) => _watchlistBox.get(k) == movieId, 
      orElse: () => null
    );
    if (key != null) {
      await _watchlistBox.delete(key);
    }
  }

  bool isInWatchlist(String movieId) {
    return _watchlistBox.values.contains(movieId);
  }

}