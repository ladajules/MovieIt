import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:movieit/providers/movie_provider.dart';
import 'package:movieit/widgets/search_result_list.dart';
import 'package:provider/provider.dart';
import '../widgets/movieit_search_bar.dart';
import '../providers/app_colors.dart';
import 'package:logger/logger.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  int? _selectedGenreId;
  double _maxRuntime = 120.0;
  double _minRating = 5.0;
  String _selectedLanguage = 'English';

  
  bool _isFilterActive = false;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .loadTrendingAndDiscoverAndTop4();
    });
  }

  var logger = Logger();

  void _onSearch(String query) {
    setState(() {
      _query = query;
      _selectedGenreId = null;
      
      _isFilterActive = false;
      
    });

    if (query.isNotEmpty) {
      Provider.of<MovieProvider>(context, listen: false).loadSearch(query);
    }
  }

  void _onGenreSelected(int genreId) {
    setState(() {
      _selectedGenreId = (_selectedGenreId == genreId) ? null : genreId;
      if (_selectedGenreId != null) _query = '';
    
      _isFilterActive = false;
      
    });

    if (_selectedGenreId != null) {
      Provider.of<MovieProvider>(context, listen: false)
          .loadSearchByGenre(genreId);
    } else {
      Provider.of<MovieProvider>(context, listen: false)
          .loadTrendingAndDiscoverAndTop4();
    }
  }

  void _onFiltersTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD3D3D3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Movie Preferences",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _maxRuntime = 120.0;
                            _minRating = 5.0;
                            _selectedGenreId = null;
                          });
                          
                          setState(() => _isFilterActive = false);
                         
                        },
                        child: const Text("Reset",
                            style: TextStyle(color: Colors.black54)),
                      )
                    ],
                  ),
                  const Text("Genre",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: [
                      28, 12, 16, 35, 80, 99, 18, 10751, 14, 36, 27, 10402,
                      9648, 10749, 878, 10770, 53, 10752, 37
                    ].map((id) {
                      final labels = {
                        28: 'Action',
                        12: 'Adventure',
                        16: 'Animation',
                        35: 'Comedy',
                        80: 'Crime',
                        99: 'Documentary',
                        18: 'Drama',
                        10751: 'Family',
                        14: 'Fantasy',
                        36: 'History',
                        27: 'Horror',
                        10402: 'Music',
                        9648: 'Mystery',
                        10749: 'Romance',
                        878: 'Sci-Fi',
                        10770: 'TV Movie',
                        53: 'Thriller',
                        10752: 'War',
                        37: 'Western',
                      };

                      final isSelected = _selectedGenreId == id;
                      return ChoiceChip(
                        label: Text(labels[id]!),
                        selected: isSelected,
                        onSelected: (val) {
                          setModalState(
                              () => _selectedGenreId = val ? id : null);
                          setState(() {});
                        },
                        labelStyle: const TextStyle(
                            color: Colors.black, fontSize: 12),
                        backgroundColor: Colors.grey[400],
                        selectedColor: Colors.grey[600],
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Runtime",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("${_maxRuntime.toInt()} mins",
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.black,
                      inactiveTrackColor: Colors.black26,
                      thumbColor: Colors.grey[600],
                      overlayColor: Colors.black12,
                    ),
                    child: Slider(
                      value: _maxRuntime,
                      min: 60,
                      max: 240,
                      onChanged: (double value) {
                        setModalState(() {
                          _maxRuntime = value;
                        });
                      },
                    ),
                  ),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Minimum Rating",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("${_minRating.toStringAsFixed(1)}+",
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.black,
                      inactiveTrackColor: Colors.black26,
                      thumbColor: Colors.grey[600],
                    ),
                    child: Slider(
                      value: _minRating,
                      min: 1.0,
                      max: 10.0,
                      divisions: 18,
                      onChanged: (double value) {
                        setModalState(() {
                          _minRating = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Language",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        items: ['English', 'Spanish', 'French']
                            .map((l) =>
                                DropdownMenuItem(value: l, child: Text(l)))
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => _selectedLanguage = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                       
                        setState(() => _isFilterActive = true);
                        

                        Provider.of<MovieProvider>(context, listen: false)
                            .loadFilteredMovies(
                          genreId: _selectedGenreId,
                          minRating: _minRating,
                          maxRuntime: _maxRuntime,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Show Recommendations",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOptions() {
    final List<Map<String, dynamic>> filters = [
      {'id': 28, 'label': 'Action'},
      {'id': 12, 'label': 'Adventure'},
      {'id': 16, 'label': 'Animation'},
      {'id': 35, 'label': 'Comedy'},
      {'id': 80, 'label': 'Crime'},
      {'id': 99, 'label': 'Documentary'},
      {'id': 18, 'label': 'Drama'},
      {'id': 10751, 'label': 'Family'},
      {'id': 14, 'label': 'Fantasy'},
      {'id': 36, 'label': 'History'},
      {'id': 27, 'label': 'Horror'},
      {'id': 10402, 'label': 'Music'},
      {'id': 9648, 'label': 'Mystery'},
      {'id': 10749, 'label': 'Romance'},
      {'id': 878, 'label': 'Sci-Fi'},
      {'id': 10770, 'label': 'TV Movie'},
      {'id': 53, 'label': 'Thriller'},
      {'id': 10752, 'label': 'War'},
      {'id': 37, 'label': 'Western'},
    ];

    return SizedBox(
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            InkWell(
              onTap: _onFiltersTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.tune, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Filters",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ...filters.map((filter) {
              final bool isSelected = _selectedGenreId == filter['id'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter['label']),
                  selected: isSelected,
                  onSelected: (_) => _onGenreSelected(filter['id']),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  backgroundColor: Colors.white.withOpacity(0.9),
                  selectedColor: const Color(0xFFA970FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  showCheckmark: false,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                MovieItSearchBar(onChanged: _onSearch),
                const SizedBox(height: 16),
                _buildFilterOptions(),
                const SizedBox(height: 16),
                Consumer<MovieProvider>(
                  builder: (context, movieProvider, child) {
                    if (movieProvider.isLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (movieProvider.errorMessage.isNotEmpty) {
                      return Center(
                          child: Text(movieProvider.errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 18)));
                    }

                    final movieListToDisplay =
                        (_query.isEmpty && _selectedGenreId == null && !_isFilterActive)
                            ? movieProvider.discoverMoviesList
                            : movieProvider.searchMoviesList;

                    if (movieListToDisplay.isEmpty &&
                        (_query.isNotEmpty ||
                            _selectedGenreId != null ||
                            _isFilterActive)) {
                    
                      return Center(
                        child: Column(
                          children: [
                            Lottie.asset('assets/animations/Search.json',
                                width: 250, height: 250),
                            const Text("No movies found.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
                          ],
                        ),
                      );
                    }

                    return SearchResultGrid(movies: movieListToDisplay);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}