class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;  
  final String? backdropUrl;
  final String? year;
  final int runtime;
  final String? rating;
  final String director;
  final String certification;
  final String language;
  final String? releaseDate;
  final String? budget; 
  final String? revenue;
  final List<CastMember> cast;  
  final List<String> genres;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterUrl,
    this.backdropUrl,
    required this.year,
    required this.runtime,
    required this.rating,
    required this.director,
    required this.certification,
    required this.language,
    this.releaseDate,
    this.budget,
    this.revenue,
    required this.cast,
    required this.genres,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json){
    return MovieDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String? ?? '',
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      year: json['year'] as String? ?? 'Unknown',
      runtime: json['runtime'] as int? ?? 0,
      rating: json['rating'] as String? ?? 'N/A',
      director: json['director'] as String? ?? 'Unknown',
      certification: json['certification'] as String? ?? 'NR',
      language: json['language'] as String? ?? 'EN',
      releaseDate: json['releaseDate'] as String?,
      budget: json['budget'] as String?,
      revenue: json['revenue'] as String?,
      genres: List<String>.from(json['genres'] ?? []),
      cast: (json['cast'] as List<dynamic>? ?? [])
          .map((c) => CastMember.fromJson(c as Map<String, dynamic>))
          .toList(),
    ); 
  }

  String get formattedRuntime {
    if (runtime <= 0) return 'N/A';
    final h = runtime ~/ 60;
    final m = runtime % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class CastMember {
  final String name;
  final String character;
  final String? profileUrl;
 
  const CastMember({
    required this.name,
    required this.character,
    this.profileUrl,
  });
 
  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['name'] as String,
      character: json['character'] as String? ?? '',
      profileUrl: json['profileUrl'] as String?,
    );
  }
}