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
    return _prefsBox.get('user_preferences') ?? UserPreferences();
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await _prefsBox.put('user_preferences', prefs);
  }

  // USER STATS
  Box<UserStats> get _statsBox => Hive.box<UserStats>(_statsBoxName);

  UserStats getStats() {
    return _statsBox.get('user_stats') ?? UserStats();
  }

  Future<void> _saveStats(UserStats stats) async {
    await _statsBox.put('user_stats', stats);
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

    stats.platformCounts[event.platform] = (stats.platformCounts[event.platform] ?? 0) + 1;
    
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

      if (stats.platformCounts.containsKey(event.platform)) {
        stats.platformCounts[event.platform] = (stats.platformCounts[event.platform]! - 1).clamp(0, 999999);
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

  // TO REMOVE SOOOOONEST
  Future<void> injectTestData() async {
    final db = LocalDbService();
    final now = DateTime.now();

    //  ============= FIRE STREAK STATE AND 2/4 MONTHLY GOAL TEST ======================
    final today = now;
    final lastWeek = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final lastMonth = DateTime(now.year, now.month - 1, 15);

    final mockEvents = [
      ScheduledEvent(
        id: 'test_1',
        movieId: "101",
        movieTitle: 'Current Week Movie',
        posterUrl: 'https://via.placeholder.com/150', // Added Poster URL
        platform: 'Netflix',
        scheduledDate: today,
        runtime: 120,
        genres: ['Action'],
        isReviewed: false,
        isWatched: true, 
      ),
      ScheduledEvent(
        id: 'test_2',
        movieId: "102",
        movieTitle: 'Last Week Movie',
        posterUrl: 'https://via.placeholder.com/150', // Added Poster URL
        platform: 'Prime',
        scheduledDate: lastWeek,
        runtime: 90,
        genres: ['Drama'],
        isReviewed: true,
        isWatched: true, 
      ),
      ScheduledEvent(
        id: 'test_3',
        movieId: "103",
        movieTitle: 'Two Weeks Ago Movie',
        posterUrl: 'https://via.placeholder.com/150', // Added Poster URL
        platform: 'Local File',
        scheduledDate: twoWeeksAgo,
        runtime: 105,
        genres: ['Sci-Fi'],
        isReviewed: false,
        isWatched: true, 
      ),
      ScheduledEvent(
        id: 'test_4',
        movieId: "104",
        movieTitle: 'Last Month Movie',
        posterUrl: 'https://via.placeholder.com/150', // Added Poster URL
        platform: 'Netflix',
        scheduledDate: lastMonth,
        runtime: 110,
        genres: ['Thriller'],
        isReviewed: true,
        isWatched: true, 
      ),
    ];

    for (var event in mockEvents) {
      await db.scheduleEvent(event);
    }

    //  =============COLD STREAK STATE AND COMPLETD MONTHLY GOAL TEST======================
  //   await _eventsBox.clear();

  //   // 2. Set up dates that are ALL in the current month, 
  //   // but restricted to just this week and last week.
  //   final today = now; 
  //   final twoDaysAgo = now.subtract(const Duration(days: 2)); 
  //   final fiveDaysAgo = now.subtract(const Duration(days: 5)); 
  //   final sevenDaysAgo = now.subtract(const Duration(days: 7)); 

  //   final mockEvents = [
  //     ScheduledEvent(
  //       id: 'test_1',
  //       movieId: "101",
  //       movieTitle: 'The Matrix',
  //       posterUrl: 'https://via.placeholder.com/150',
  //       platform: 'Netflix',
  //       scheduledDate: today,
  //       runtime: 136,
  //       genres: ['Sci-Fi'],
  //       isReviewed: false,
  //       isWatched: true, // +1 Month, +1 Week Streak
  //     ),
  //     ScheduledEvent(
  //       id: 'test_2',
  //       movieId: "102",
  //       movieTitle: 'Inception',
  //       posterUrl: 'https://via.placeholder.com/150',
  //       platform: 'Netflix',
  //       scheduledDate: twoDaysAgo,
  //       runtime: 148,
  //       genres: ['Sci-Fi'],
  //       isReviewed: true,
  //       isWatched: true, // +1 Month, (Same Week Streak)
  //     ),
  //     ScheduledEvent(
  //       id: 'test_3',
  //       movieId: "103",
  //       movieTitle: 'Dune',
  //       posterUrl: 'https://via.placeholder.com/150',
  //       platform: 'Netflix',
  //       scheduledDate: fiveDaysAgo,
  //       runtime: 155,
  //       genres: ['Sci-Fi'],
  //       isReviewed: false,
  //       isWatched: true, // +1 Month, +1 Week Streak (Last Week)
  //     ),
  //     ScheduledEvent(
  //       id: 'test_4',
  //       movieId: "104",
  //       movieTitle: 'Arrival',
  //       posterUrl: 'https://via.placeholder.com/150',
  //       platform: 'Netflix',
  //       scheduledDate: sevenDaysAgo,
  //       runtime: 116,
  //       genres: ['Sci-Fi'],
  //       isReviewed: true,
  //       isWatched: true, // +1 Month, (Same Week Streak)
  //     ),
  //   ];

  //   for (var event in mockEvents) {
  //     await db.scheduleEvent(event);
  //   }



  }
}