
class Movie{
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;
  final String? backdropUrl;
  final String? year;
  final String? rating;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.year,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Unknown',
      overview: json['overview'] ?? 'No overview available',
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      year: json['year']?.toString(),
      rating: (json['popularity'] as num?)?.round().toString(),   
    );
  }
}