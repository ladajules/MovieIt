import 'package:hive/hive.dart';
part 'user_preferences.g.dart';

@HiveType(typeId: 1)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool notificationsEnabled;

  @HiveField(1)
  String calendarView; // monthly or weekly

  UserPreferences({
    this.notificationsEnabled = true,
    this.calendarView = 'monthly',
  });
}

