import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_details_model.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:movieit/models/sources_model.dart';




class ApiClient {
  
  static const String _baseUrl = 'http://localhost:3000/api/movies';
  static const String _baseUrlWatchmode = 'http://localhost:3000/api/watchmode';


    var logger = Logger ();
 
    Future<List<Movie>> getTrendingMovies() async {
        try{
            final response = await http.get(Uri.parse('$_baseUrl/trending'));
            if (response.statusCode == 200) {
              List<dynamic> data = jsonDecode(response.body);
              return data.map((json) => Movie.fromJson(json)).toList();
            } else {
            throw Exception('Failed to load trending movies');
            }
        } catch (e){
            logger.e('ApiClient error (Trending), $e');
            rethrow;
        }
       
    }


    Future<List<Movie>> getTop4() async {
      try{
        final response = await http.get(Uri.parse('$_baseUrl/topFour'));
        if (response.statusCode == 200){
          List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load top 4 movies');
        }
      } catch (e){
        logger.e('ApiClient error (Top 4), $e');
        rethrow;
      }
    }


    Future<List<Movie>> getDiscoverMovies() async{
        try{
            final response = await http.get(Uri.parse('$_baseUrl/discover'));
            if (response.statusCode == 200){
              List<dynamic> data = jsonDecode(response.body);
              return data.map((json) => Movie.fromJson(json)).toList();
            } else {
                throw Exception('Failed to load discover movies');
            }
        } catch (e){
            logger.e('ApiClient error (Discover), $e');
            rethrow;
        }
    }


    Future<List<Movie>> getSearchMovies(String query) async{
        try{
            final response = await http.get(Uri.parse('$_baseUrl/search?query=$query'));
            if (response.statusCode == 200){
              List<dynamic> data = jsonDecode(response.body);
              return data.map((json) => Movie.fromJson(json)).toList();
            } else {
                throw Exception('Failed to load search movies');
            }
        } catch (e){
            logger.e('ApiClient error (Search), $e');
            rethrow;
        }
    }


    Future<MovieDetails> getMovieDetails(String movieId) async {
        try{
            final response = await http.get(Uri.parse('$_baseUrl/$movieId'));
            if (response.statusCode == 200){
                return MovieDetails.fromJson(jsonDecode(response.body));
            } else {
               
                throw Exception('Failed to load movie details: ${response.statusCode}');
            }
        } catch (e){
            logger.e('ApiClient error (Movie Details), $e');
            rethrow;
        }  
    }


    Future<List<Movie>> getPopularPHMovies() async {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/popular-ph'));


        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load popular movies in Philippines');
        }


      } catch (e) {
        logger.e('ApiClient error (Popular PH), $e');
        rethrow;
      }
    }


    Future<List<Movie>> getUpcomingMovies() async {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/upcoming'));


        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load upcoming movies');
        }


      } catch (e) {
        logger.e('ApiClient error (Upcoming), $e');
        rethrow;
      }


    }


    Future<List<Sources>> getSources(String tmdbId) async {
      try{
        final response = await http.get(Uri.parse('$_baseUrlWatchmode/$tmdbId'));


        if (response.statusCode == 200){
          List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Sources.fromJson(json)).toList();
        } else if (response.statusCode == 204) {
          return []; // Gracefully return an empty list when no sources are found
        } else {
          throw Exception('Failed to load sources: ${response.statusCode}');
        }


      } catch (e){
        logger.e('ApiClient error (Sources), $e');
        rethrow;
      }
    }
   
    Future<List<Movie>> getFilteredMovies({
      List<int>? genres,
      bool matchAll = false,
      double? minRuntime,
      double? maxRuntime,
      double? minRating,
      List<String>? languages,
    }) async {
      try {
        final Map<String, String> queryParameters = {};
      
        if (genres != null && genres.isNotEmpty) {
          queryParameters['genres'] = genres.join(',');
        }

        queryParameters['matchAll'] = matchAll.toString();

        if (minRuntime != null) {
          queryParameters['minRuntime'] = minRuntime.toInt().toString();
        }
        
        if (maxRuntime != null) {
          queryParameters['maxRuntime'] = maxRuntime.toInt().toString();
        }

        if (minRating != null) {
          queryParameters['minRating'] = minRating.toString();
        }

        if (languages != null && languages.isNotEmpty) {
          queryParameters['languages'] = languages.join(',');
        }

        final uri = Uri.parse('$_baseUrl/filter').replace(queryParameters: queryParameters);

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load filtered movies: ${response.statusCode}');
        }
      } catch (e) {
        logger.e('ApiClient error (Filtered Movies), $e');
        rethrow;
      }
    }
 
  Future<List<Movie>> getMoviesByGenre(String genreId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/genre/$genreId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies for genre ID: $genreId');
      }
    } catch (e) {
      logger.e('ApiClient error (Genre), $e');
      rethrow;
    }
  }

  Future<List<Movie>> getSimilarMovies(String movieId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$movieId/similar'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load similar movies for movie ID: $movieId');
      }
      
    } catch (error) {
      logger.e('ApiClient error (Similar Movies), $error');
      rethrow;
    }
  }

  Future<Map<int, String>> getGenres() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/genres'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {for (var item in data) item['id'] as int: item['name'] as String};
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      logger.e('ApiClient error (Genres), $e');
      rethrow;
    }
  }

  Future<Map<String, String>> getLanguages() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/languages'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {for (var item in data) item['code'] as String: item['name'] as String};
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      logger.e('ApiClient error (Languages), $e');
      rethrow;
    }
  }


}






 


 
