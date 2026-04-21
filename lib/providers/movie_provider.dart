import 'package:flutter/material.dart';
import 'package:movieit/services/api_client.dart';

class MovieProvider extends ChangeNotifier{
  final ApiClient apiClient = ApiClient();

  List<dynamic> _trendingMovies = [];
  List<dynamic> _discoverMovies = [];
  List<dynamic> _searchMovies = [];
  Map<String, dynamic> _movieDetails = {};

  bool _isLoading = false;
  String _errorMessage = '';

  //getters
  
  List<dynamic> get trendingMoviesList => _trendingMovies;
  List<dynamic> get discoverMoviesList => _discoverMovies;
  List<dynamic> get searchMoviesList => _searchMovies;
  Map<String, dynamic> get movieDetailsMap => _movieDetails;
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadTrendingAndDiscover() async {
    _setLoading(true);
    try{
      final results = await Future.wait([
        apiClient.getTrendingMovies(),
        apiClient.getDiscoverMovies(),

      ]);

      _trendingMovies = results[0];
      _discoverMovies = results[1];
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
      _movieDetails = await apiClient.getMovieDetails(movieId);
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