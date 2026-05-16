import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:movieit/models/user_preferences.dart';
import 'package:movieit/widgets/universal_banner.dart';

class NotificationEngine {
  static Timer? _timer;

  static void start(BuildContext context){
    if (_timer != null && _timer!.isActive)return;

    _timer = Timer.periodic(const Duration(minutes: 1), (timer){
     _checkForUpcomingMovies(context);
    });
  }

  static void stop(){
    _timer?.cancel();
    _timer = null;
  }

  static void _checkForUpcomingMovies(BuildContext context){
    final prefsBox = Hive.box<UserPreferences>('user_preferences');
    final prefs = prefsBox.get('current_prefs');

    if (prefs != null && !prefs.notificationsEnabled) return;

    final eventsBox = Hive.box<ScheduledEvent>('scheduled_event');
    final now = DateTime.now();

    for(var event in eventsBox.values){
      final reminderTime = event.scheduledDate.subtract(
        Duration(minutes: event.reminderOffsetMinutes),
      );

      if (event.isNotified) return;

      if (now.isAfter(reminderTime)){
        UniversalBanner.show(
          context: context, 
          title: "Movie scheduled in ${event.reminderOffsetMinutes} mins!",
          subTitle: "Get ready to watch ${event.movieTitle} on ${event.platform}.",
          imageUrl: event.posterUrl,
        );

        event.isNotified = true;
        event.save();
      }
    }
  }
}
