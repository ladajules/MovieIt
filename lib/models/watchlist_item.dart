import 'package:hive/hive.dart';
part 'watchlist_item.g.dart';

@HiveType(typeId: 5)
class WatchlistItem extends HiveObject {
  @HiveField(0)
  final int tmdbId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath; 

  @HiveField(3)
  final int runtimeMinutes;

  @HiveField(4)
  final List<int> genreIds;

  @HiveField(5)
  DateTime cachedAt;

  WatchlistItem({
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    required this.runtimeMinutes,
    required this.genreIds,
    required this.cachedAt,
  });
}