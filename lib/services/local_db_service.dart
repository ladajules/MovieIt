import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheduled_event.dart';
import '../models/user_stats.dart';
import '../models/user_preferences.dart';
import '../models/watchlist_item.dart';
import 'package:flutter/foundation.dart';

class LocalDbService {
  static const String _eventsBoxName = 'scheduled_event';
  static const String _statsBoxName = 'user_stats';
  static const String _prefsBoxName = 'user_preferences';
  static const String _watchlistBoxName = 'watchlist';

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

  ValueListenable<Box<ScheduledEvent>> listenToEvents() {
    return _eventsBox.listenable();
  }

  // WAATCHLIST
  Box<WatchlistItem> get _watchlistBox => Hive.box<WatchlistItem>(_watchlistBoxName);

  bool isInWatchlist(int movieId) {
    return _watchlistBox.containsKey(movieId);
  }

  Future<void> toggleWatchlist(WatchlistItem item) async {
    if (_watchlistBox.containsKey(item.tmdbId)) {
      await _watchlistBox.delete(item.tmdbId);
    } else {
      await _watchlistBox.put(item.tmdbId, item);
    }
  }

  ValueListenable<Box<WatchlistItem>> listenToWatchlist() {
    return _watchlistBox.listenable();
  }

}