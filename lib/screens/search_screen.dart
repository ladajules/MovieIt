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

    @override
    void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<MovieProvider>(context, listen: false).loadTrendingAndDiscoverAndTop4();
    });
    }

    var logger = Logger();

    void _onSearch(String query) {
        setState(() => _query = query);
        
        if (query.isNotEmpty){
          Provider.of<MovieProvider>(context, listen: false).loadSearch(query);
        }
    }

    void _onGenreSelected(int genreId) {
        setState(() => _selectedGenreId = genreId);
        // TODO: call read<MovieProvider>().filterByGenre(genreId)
    }

    void _onFiltersTap() {
        // TODO: show movie preferences modal (filters)
        logger.i("Filters tapped...");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // search bar
                        MovieItSearchBar(onChanged: _onSearch),
                        const SizedBox(height: 16),

                        // filter btn and genre chips

                        // results grid
                        const SizedBox(height: 16),

                      Consumer<MovieProvider>(
                        builder: (context, movieProvider, child){
                          if (movieProvider.isLoading){
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                           if(movieProvider.errorMessage.isNotEmpty){
                            return Center(child: Text(movieProvider.errorMessage, style: const TextStyle(color: Colors.red, fontSize: 18)));
                          }
                          final movieListToDisplay = _query.isEmpty ? movieProvider.discoverMoviesList : movieProvider.searchMoviesList;

                          if (movieListToDisplay.isEmpty && _query.isNotEmpty){
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/Search.json',  
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.fill,
                                  ),
                                const SizedBox(height: 20),
                                const Text(
                                  "We couldn't find any movies.",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            );
                          }

                          return SearchResultGrid(movies: movieListToDisplay);

                        }
                      )

                    ],
                ),
            ),
        ),
    );
  }


}