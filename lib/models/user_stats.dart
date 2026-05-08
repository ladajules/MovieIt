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

  UserStats({
    this.nightsPlanned = 0,
    this.totalRuntimeMinutes = 0,
    this.totalRatingSum = 0.0,
    this.totalMoviesRated = 0,
    Map<String, int>? genreCounts,
  }) : genreCounts = genreCounts ?? {};

  double get averageRating => totalMoviesRated == 0 ? 0.0 : totalRatingSum / totalMoviesRated;
}