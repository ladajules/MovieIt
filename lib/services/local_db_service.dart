import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheduled_event.dart';
import '../models/user_stats.dart';
import '../models/user_preferences.dart';
import '../models/watchlist_item.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';

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


  // IMPORT EXPORT
  Future<void> exportDatabase() async {
    final stats = getStats();
    
    final backup = {
      'scheduled_events': _eventsBox.values.map((e) => {
        'id': e.id,
        'movieId': e.movieId,
        'movieTitle': e.movieTitle,
        'posterUrl': e.posterUrl,
        'platform': e.platform,
        'scheduledDate': e.scheduledDate.toIso8601String(),
        'runtime': e.runtime,
        'genres': e.genres,
        'isReviewed': e.isReviewed,
        'isWatched': e.isWatched,
        'rating': e.rating, 
        'note': e.note, 
      }).toList(),
      'user_stats': {
        'nightsPlanned': stats.nightsPlanned,
        'totalRuntimeMinutes': stats.totalRuntimeMinutes,
        'totalRatingSum': stats.totalRatingSum,
        'totalMoviesRated': stats.totalMoviesRated,
        'genreCounts': stats.genreCounts,
        'platformCounts': stats.platformCounts, 
      },
      'watchlist': _watchlistBox.values.map((w) => {
        'tmdbId': w.tmdbId,
        'title': w.title,
        'posterPath': w.posterPath,
        'runtimeMinutes': w.runtimeMinutes,
        'genreIds': w.genreIds,
        'cachedAt': w.cachedAt.toIso8601String(),
      }).toList(),
    };

    final jsonString = jsonEncode(backup);

    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'movieit_backup.json')
      ..click(); 
      
    html.Url.revokeObjectUrl(url);
  }

  Future<bool> importDatabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final jsonString = utf8.decode(result.files.single.bytes!);
      final Map<String, dynamic> backup = jsonDecode(jsonString);

      await _eventsBox.clear();
      if (backup['scheduled_events'] != null) {
        for (var e in backup['scheduled_events']) {
          final event = ScheduledEvent(
            id: e['id'],
            movieId: e['movieId'],
            movieTitle: e['movieTitle'],
            posterUrl: e['posterUrl'],
            platform: e['platform'],
            scheduledDate: DateTime.parse(e['scheduledDate']),
            runtime: e['runtime'],
            genres: List<String>.from(e['genres'] ?? []),
            isReviewed: e['isReviewed'] ?? false,
            isWatched: e['isWatched'] ?? false,
            reminderOffsetMinutes: e['reminderOffsetMinutes'] ?? 0,
            isNotified: e['isNotified'] ?? false,
          );
          event.rating = e['rating']?.toDouble();
          event.note = e['note'];
          await _eventsBox.put(event.id, event);
        }
      }

      if (backup['user_stats'] != null) {
        final s = backup['user_stats'];
        final stats = UserStats(
          nightsPlanned: s['nightsPlanned'] ?? 0,
          totalRuntimeMinutes: s['totalRuntimeMinutes'] ?? 0,
          totalRatingSum: s['totalRatingSum']?.toDouble() ?? 0.0,
          totalMoviesRated: s['totalMoviesRated'] ?? 0,
          genreCounts: Map<String, int>.from(s['genreCounts'] ?? {}),
        );
        if (s['platformCounts'] != null) {
          stats.platformCounts = Map<String, int>.from(s['platformCounts']);
        }
        await _saveStats(stats);
      }

      await _watchlistBox.clear();
      if (backup['watchlist'] != null) {
        for (var w in backup['watchlist']) {
          final item = WatchlistItem(
            tmdbId: w['tmdbId'],
            title: w['title'],
            posterPath: w['posterPath'],
            runtimeMinutes: w['runtimeMinutes'],
            genreIds: List<int>.from(w['genreIds'] ?? []),
            cachedAt: DateTime.parse(w['cachedAt']),
          );
          await _watchlistBox.put(item.tmdbId, item);
        }
      }

      return true;
    }
    return false; 
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
        reminderOffsetMinutes: 10,
        isNotified: false,
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
        reminderOffsetMinutes: 10,
        isNotified: false, 
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
        reminderOffsetMinutes: 10,
        isNotified: false,
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
        reminderOffsetMinutes: 10,
        isNotified: false,
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