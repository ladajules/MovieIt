import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieit/models/sources_model.dart';
import 'package:movieit/widgets/where_to_watch_section.dart';
import '../models/movie_details_model.dart';
import '../widgets/movie_detail_hero_section.dart';
import '../widgets/cast_grid.dart';
import '../services/api_client.dart';

import '../services/local_db_service.dart';
import '../models/watchlist_item.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetails> _movieFuture;
  late Future<List<Sources>> _sourcesFuture;

  final _dbService = LocalDbService();
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _fetchData();

    final id = int.tryParse(widget.movieId) ?? 0;
    _isInWatchlist = _dbService.isInWatchlist(id);
  }

  void _fetchData() {
    _movieFuture = ApiClient().getMovieDetails(widget.movieId.toString());
    _sourcesFuture = ApiClient().getSources(widget.movieId.toString());
  }

  Future<void> _toggleWatchlist(MovieDetails movie) async {
    final item = WatchlistItem(
      tmdbId: movie.id,
      title: movie.title,
      posterPath: movie.posterUrl ?? '', 
      runtimeMinutes: movie.runtime ?? 0,
      genreIds: movie.genres.map((g) => g.hashCode).toList(), 
      cachedAt: DateTime.now().toUtc(),
    );

    await _dbService.toggleWatchlist(item);

    setState(() {
      _isInWatchlist = _dbService.isInWatchlist(movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetails>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _ErrorView(
              message: snapshot.error?.toString() ?? 'Something went wrong.',
              onRetry: () => setState(() {
                _movieFuture = ApiClient().getMovieDetails(widget.movieId.toString());
                _sourcesFuture = ApiClient().getSources(widget.movieId.toString());
              }),
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    MovieHeroSection(
                      movie: movie,
                      isInWatchlist: _isInWatchlist,
                      onAddToWatchlist: () => _toggleWatchlist(movie),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 46, top: 8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               const SliverToBoxAdapter(child: SizedBox(height: 46))  ,
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: FutureBuilder<List<Sources>>(
                    future: _sourcesFuture,
                    builder: (context, sourcesSnapshot) {
                      if (sourcesSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFA970FF)));
                      }
                      return WhereToWatchSection(sources: sourcesSnapshot.data);
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 46)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: CastGrid(cast: movie.cast),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFA970FF)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(
            'Could not load movie',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(color: Color(0xFFA970FF))),
          ),
        ],
      ),
    );
  }
}