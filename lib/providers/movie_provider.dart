import 'package:flutter/material.dart';
import 'package:movieit/models/movie_details_model.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:movieit/models/sources_model.dart';
import 'package:movieit/services/api_client.dart';


class MovieProvider extends ChangeNotifier{
  final ApiClient apiClient = ApiClient();


  List<Movie> _trendingMovies = [];
  List<Movie> _discoverMovies = [];
  List<Movie> _searchMovies = [];
  List<Movie> _top4Movies = [];
  List<Movie> _popularPHMovies = [];
  List<Movie> _upcomingMovies = [];
  MovieDetails? _movieDetails;
  List<Sources>? _sourcesList = [];
  List<Movie> _getSimilarMovies = [];


  bool _isLoading = false;
  String _errorMessage = '';


  //getters
 
  List<Movie> get trendingMoviesList => _trendingMovies;
  List<Movie> get discoverMoviesList => _discoverMovies;
  List<Movie> get searchMoviesList => _searchMovies;
  List<Movie> get top4MoviesList => _top4Movies;
  List<Movie> get popularPHMoviesList => _popularPHMovies;
  List<Movie> get upcomingMoviesList => _upcomingMovies;
  MovieDetails? get movieDetailsMap => _movieDetails;
  List<Sources>? get sourcesList => _sourcesList;
  List<Movie> get getSimilarMovies => _getSimilarMovies;
 
 
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;


  Future<void> loadFilteredMovies({
    int? genreId,
    required double minRating,
    required double maxRuntime,
    required String language,
  }) async {
    _setLoading(true);
    _searchMovies.clear(); // Clear previous results to show fresh filtered ones


    try {
      // Note: We call a new method in apiClient (which we'll define below)
      final results = await apiClient.getFilteredMovies(
        genreId: genreId?.toString(),
        minRating: minRating,
        maxRuntime: maxRuntime,
        language: language,
      );


      _searchMovies = results;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'No movies match your current filters.';
      debugPrint("Filter Error: $e");
    } finally {
      _setLoading(false);
    }
  }


  Future<void> loadTrendingAndDiscoverAndTop4() async {
    _setLoading(true);
    try{
      final results = await Future.wait([
        apiClient.getTrendingMovies(),
        apiClient.getDiscoverMovies(),
        apiClient.getTop4(),
        apiClient.getPopularPHMovies(),
        apiClient.getUpcomingMovies(),
      ]);


      _trendingMovies = results[0];
      _discoverMovies = results[1];
      _top4Movies = results[2];
      _popularPHMovies = results[3];
      _upcomingMovies = results[4];
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
    _searchMovies.clear();
    try{
      _searchMovies = await apiClient.getSearchMovies(query);
      _errorMessage = '';
    } catch (e){
      _errorMessage = 'Failed to load search movies';
    } finally{
      _setLoading(false);
    }
  }


 Future<void> loadSearchByGenre(int genreId) async {
  _setLoading(true);
  _searchMovies.clear(); // We reuse searchMovies to display results in the grid
  try {
    _searchMovies = await apiClient.getMoviesByGenre(genreId.toString());
    _errorMessage = '';
  } catch (e) {
    _errorMessage = 'Failed to load genre results';
  } finally {
    _setLoading(false);
  }
}


  Future<void> LoadMovieDetails(int movieId) async {
    _setLoading(true);  
    _movieDetails = null;
    try{
      _movieDetails = await apiClient.getMovieDetails(movieId.toString());
      _errorMessage = '';
    } catch(e){
      _errorMessage = 'Failed to load movie details';
    } finally{
      _setLoading(false);
    }
  }


  Future<void> loadSources(String tmdbId) async {
    _setLoading(true);
    _sourcesList = null;
    try{
      _sourcesList = await apiClient.getSources(tmdbId);
      _errorMessage = '';
    } catch(e){
      _errorMessage = 'Failed to load sources';
    } finally{
      _setLoading(false);
    }
  }


 




  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
 
  }






}
