import 'package:flutter/material.dart';
import 'package:movieit/models/movie_details_model.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:movieit/services/api_client.dart';

class MovieProvider extends ChangeNotifier{
  final ApiClient apiClient = ApiClient();

  List<Movie> _trendingMovies = [];
  List<Movie> _discoverMovies = [];
  List<Movie> _searchMovies = [];
  List<Movie> _top4Movies = [];
  MovieDetails? _movieDetails;

  bool _isLoading = false;
  String _errorMessage = '';

  //getters
  
  List<Movie> get trendingMoviesList => _trendingMovies;
  List<Movie> get discoverMoviesList => _discoverMovies;
  List<Movie> get searchMoviesList => _searchMovies;
  List<Movie> get top4MoviesList => _top4Movies;
  MovieDetails? get movieDetailsMap => _movieDetails;
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadTrendingAndDiscoverAndTop4() async {
    _setLoading(true);
    try{
      final results = await Future.wait([
        apiClient.getTrendingMovies(),
        apiClient.getDiscoverMovies(),
        apiClient.getTop4(),
      ]);

      _trendingMovies = results[0];
      _discoverMovies = results[1];
      _top4Movies = results[2];
      _errorMessage = '';
    } catch (e){
      _errorMessage = 'Failed to load trending and discover movies';
    } finally{
      _setLoading(false);
    }
  }

  Future<void> loadSearch(String query) async {
    if((query.isEmpty)){
      return;
    }

    _setLoading(true);
    try{
      _searchMovies = await apiClient.getSearchMovies(query);
      _errorMessage = '';
    } catch (e){
      _errorMessage = 'Failed to load search movies';
    } finally{
      _setLoading(false);
    }
  }

  Future<void> LoadMovieDetails(int movieId) async {
    _setLoading(true);  
    try{
      _movieDetails = await apiClient.getMovieDetails(movieId.toString());
      _errorMessage = '';
    } catch(e){
      _errorMessage = 'Failed to load movie details';
    } finally{
      _setLoading(false);
    }
  }


  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  
  }


}