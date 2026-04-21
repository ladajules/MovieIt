
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';


class ApiClient {
    
  static const String _baseUrl = 'http://localhost:3000/api/movies';
    var logger = Logger ();
  
    Future<List<dynamic>> getTrendingMovies() async {
        try{
            final response = await http.get(Uri.parse('$_baseUrl/trending'));
            if (response.statusCode == 200) {
            return jsonDecode(response.body);
            } else {
            throw Exception('Failed to load trending movies');
            }
        } catch (e){
            logger.e('ApiClient error (Trending), $e');
            rethrow;
        }
        
    }

    Future<List<dynamic>> getDiscoverMovies() async{
        try{
            final response = await http.get(Uri.parse('$_baseUrl/discover'));
            if (response.statusCode == 200){
                return jsonDecode(response.body);
            } else {
                throw Exception('Failed to load discover movies');
            }
        } catch (e){
            logger.e('ApiClient error (Discover), $e');
            rethrow;
        }
    }

    Future<List<dynamic>> getSearchMovies(String query) async{
        try{
            final response = await http.get(Uri.parse('$_baseUrl/search?query=$query'));
            if (response.statusCode == 200){
                return jsonDecode(response.body);
            } else {
                throw Exception('Failed to load search movies');
            }
        } catch (e){
            logger.e('ApiClient error (Search), $e');
            rethrow;
        }
    }

    Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
        try{
            final response = await http.get(Uri.parse('$_baseUrl/$movieId'));
            if (response.statusCode == 200){
                return jsonDecode(response.body);
            } else {
                throw Exception('Failed to load movie details');
            }
        } catch (e){
            logger.e('ApiClient error (Movie Details), $e');
            rethrow;
        }   
    }  
}

