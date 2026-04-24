class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;  
  final String? backdropUrl;
  final String? year;
  final String? rating;
  final String? ageRating;
  final String? runtime;
  final String? director;
  final List<String> cast;  
  final List<String> genres;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.year,
    this.rating,
    this.ageRating,
    this.runtime,
    this.director,
    this.cast = const [],   
    this.genres = const [],
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json){
    return MovieDetails(
      id: json['id'] ?? 0, 
      title: json['title'] ?? 'Unknown',
      overview: json['overview'] ?? 'No overview available',
      
      posterUrl: json['posterUrl'], 
      backdropUrl: json['backdropUrl'],
      year: json['year']?.toString(),
      rating: json['rating']?.toString(),
      ageRating: json['ageRating']?.toString(), 
      runtime: json['runtime']?.toString(),
      director: json['director']?.toString(),
      
      cast: List<String>.from(json['cast'] ?? []),
      genres: List<String>.from(json['genre'] ?? []), 
    );  
  }
}