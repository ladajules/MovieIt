import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:movieit/models/user_preferences.dart';
import 'package:movieit/widgets/universal_banner.dart';

class NotificationEngine {
  static Timer? _timer;
  
  static Logger log = Logger();
  static void start(BuildContext context){
    if (_timer != null && _timer!.isActive)return;

    _timer = Timer.periodic(const Duration(seconds: 15), (timer){
     _checkForUpcomingMovies(context);
    });
  }

  static void stop(){
    _timer?.cancel();
    _timer = null;
  }

  static void _checkForUpcomingMovies(BuildContext context){
    final prefsBox = Hive.box<UserPreferences>('user_preferences');
    final prefs = prefsBox.get('current_prefs') ?? UserPreferences();

    if (prefs != null && !prefs.notificationsEnabled) return;

    final eventsBox = Hive.box<ScheduledEvent>('scheduled_event');
    final now = DateTime.now();

    for(var event in eventsBox.values){

      if (event.isNotified) continue;

      final reminderTime = event.scheduledDate.subtract(
        Duration(minutes: event.reminderOffsetMinutes),
      );

      String convertedTime = _formatReminderTime(event.reminderOffsetMinutes);  
      

      if (now.isAfter(reminderTime) && now.isBefore(event.scheduledDate)){
        UniversalBanner.show(
          context: context, 
          title: "Movie scheduled in $convertedTime",
          subTitle: "Get ready to watch ${event.movieTitle} on ${event.platform}.",
          imageUrl: event.posterUrl,
        );

        event.isNotified = true;
        event.save();
      }
    }
  }

  static String _formatReminderTime(int reminderTime){
    int convertedTime;
    String placeholder;
    if (reminderTime % 1440 == 0){
      convertedTime = reminderTime ~/ 1440;
      if (convertedTime == 1) {
        placeholder = "Day";
      } else {
        placeholder = "Days";
      }
      return "$convertedTime $placeholder!";
    } else if (reminderTime % 60 == 0){
      convertedTime = reminderTime ~/ 60;
      if (convertedTime == 1) {
        placeholder = "Hour";
      } else {
        placeholder = "Hours";
      }
      return "$convertedTime $placeholder!";
    } 
    if (reminderTime == 1){
      placeholder = "Minute";
    } else {
      placeholder = "Minutes";
    }
    return "$reminderTime $placeholder!";
  }

}


