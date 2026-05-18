
class Movie{
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;
  final String? backdropUrl;
  final String? year;
  final String? rating;
  final List<int>? genreIds;
  final int? runtime;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.year,
    this.rating,
    this.genreIds,
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Unknown',
      overview: json['overview'] ?? 'No overview available',
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      year: json['year']?.toString(),
      rating: json['rating']?.toString(),   
      genreIds: (json['genres'] as List<dynamic>?)?.map((e) => e as int).toList(),
      runtime: json['runtime'] as int?,
    );
  }
}