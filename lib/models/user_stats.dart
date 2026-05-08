import 'package:hive/hive.dart';
part 'user_stats.g.dart';

@HiveType(typeId: 2)
class UserStats extends HiveObject {
  @HiveField(0)
  int nightsPlanned;

  @HiveField(1)
  int totalRuntimeMinutes;

  @HiveField(2)
  double totalRatingSum; 

  @HiveField(3)
  int totalMoviesRated;

  @HiveField(4)
  Map<String, int> genreCounts; 

  @HiveField(5) 
  Map<String, int> platformCounts;

  @HiveField(6)
  int streakPersonalBest;

  UserStats({
    this.nightsPlanned = 0,
    this.totalRuntimeMinutes = 0,
    this.totalRatingSum = 0.0,
    this.totalMoviesRated = 0,
    Map<String, int>? genreCounts,
    Map<String, int>? platformCounts,
    this.streakPersonalBest = 0,
  }) : genreCounts = genreCounts ?? {},
       platformCounts = platformCounts ?? {};

  double get averageRating => totalMoviesRated == 0 ? 0.0 : totalRatingSum / totalMoviesRated;
}