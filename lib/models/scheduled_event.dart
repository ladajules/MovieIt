import 'package:hive/hive.dart';
part 'scheduled_event.g.dart';

@HiveType(typeId: 3)
class ScheduledEvent extends HiveObject {
  @HiveField(0)
  final String id; 

  @HiveField(1)
  final String movieId;

  @HiveField(2)
  final String movieTitle;

  @HiveField(3)
  final String posterUrl;

  @HiveField(4)
  final DateTime scheduledDate;

  @HiveField(5)
  final String platform; 

  @HiveField(6)
  final int runtime; 

  @HiveField(7)
  final List<String> genres; 

  @HiveField(8)
  bool isReviewed;

  @HiveField(9)
  double? rating;

  @HiveField(10)
  String? note;

  ScheduledEvent({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.scheduledDate,
    required this.platform,
    required this.runtime,
    required this.genres,
    this.isReviewed = false,
    this.rating,
    this.note,
  });
}