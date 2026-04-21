import 'package:flutter/material.dart';

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

    bool get _isLoading => true;

    var logger = Logger();

    void _onSearch(String query) {
        setState(() => _query = query);
        // TODO: search through the movies by calling read<MovieProvider>().search(query)
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
                padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // search bar
                        MovieItSearchBar(onChanged: _onSearch),
                        const SizedBox(height: 16),

                        // filter btn and genre chips

                        // results grid
                    ],
                ),
            ),
        ),
    );
  }
}