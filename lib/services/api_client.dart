
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_details_model.dart';
import 'package:movieit/models/movie_models.dart';


class ApiClient {
    
  static const String _baseUrl = 'http://localhost:3000/api/movies';
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

    Future<MovieDetails> getMovieDetails(int movieId) async {
        try{
            final response = await http.get(Uri.parse('$_baseUrl/$movieId'));
            if (response.statusCode == 200){
                return MovieDetails.fromJson(jsonDecode(response.body));
            } else {
                throw Exception('Failed to load movie details');
            }
        } catch (e){
            logger.e('ApiClient error (Movie Details), $e');
            rethrow;
        }   
    }  
}

