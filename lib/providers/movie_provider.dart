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
  Map<int, String> _genreLabels = {};
  Map<String, String> _languageLabels = {};

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
  Map<int, String> get genreLabels => _genreLabels;
  Map<String, String> get languageLabels => _languageLabels;
 
 
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;


  Future<void> loadFilteredMovies({
    List<int>? genres,
    bool matchAll = false,
    double? minRuntime,
    double? maxRuntime,
    double? minRating,
    List<String>? languages,
  }) async {
    _setLoading(true);
    _searchMovies.clear();

    try {
      final results = await apiClient.getFilteredMovies(
        genres: genres,
        matchAll: matchAll,
        minRuntime: minRuntime,
        maxRuntime: maxRuntime,
        minRating: minRating,
        languages: languages,
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

  Future<void> loadFilterOptions() async {
    if (_genreLabels.isNotEmpty && _languageLabels.isNotEmpty) return;

    try {
      final results = await Future.wait([
        apiClient.getGenres(),
        apiClient.getLanguages(),
      ]);

      _genreLabels = results[0] as Map<int, String>;
      _languageLabels = results[1] as Map<String, String>;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load filter options: $e");
    }
  }


 




  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
 
  }






}
