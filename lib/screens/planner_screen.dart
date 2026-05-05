import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/movie_models.dart';
import '../widgets/two_tone_card.dart';
import '../widgets/metric_box.dart';
import '../widgets/genre_bar.dart';
import '../widgets/movie_card_horizontal.dart';
import '../widgets/calendar_section.dart';
import '../providers/app_colors.dart';

class PlannerScreen extends StatelessWidget {
  final List<Movie>? watchlistMovies;

  const PlannerScreen({
    super.key,
    this.watchlistMovies,
  });

  @override
  Widget build(BuildContext context) {
    final safeMoviesList = watchlistMovies ?? [];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // stats dashbaord
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _StatsSection(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // calendar
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CalendarSection(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // pending review or notes
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _PendingReviewCard(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),

                // watchlist 
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      "Your Watchlist",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                _WatchlistHorizontalList(movies: safeMoviesList),
                
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WatchlistHorizontalList extends StatelessWidget {
  final List<Movie> movies;

  const _WatchlistHorizontalList({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          alignment: Alignment.center,
          child: const Text(
            "Your watchlist is empty.",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280, 
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(item: movies[index]); 
          },
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return const TwoToneCard(
      title: "Dashboard",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: MetricBox(value: "8", label: "Nights planned")),
              SizedBox(width: 12),
              Expanded(child: MetricBox(value: "19h", label: "Total runtime")),
              SizedBox(width: 12),
              Expanded(child: MetricBox(value: "4.2", label: "Avg rating")),
            ],
          ),
          SizedBox(height: 24),
          Text("TOP GENRES", style: TextStyle(color: AppColors.white, fontSize: 12, letterSpacing: 1.2)),
          SizedBox(height: 12),
          GenreBar(genre: "Sci-Fi", percentage: 85),
          SizedBox(height: 12),
          GenreBar(genre: "Drama", percentage: 60),
          SizedBox(height: 12),
          GenreBar(genre: "Action", percentage: 45),
        ],
      ),
    );
  }
}

class _PendingReviewCard extends StatelessWidget {
  const _PendingReviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBody,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.softPeriwinkle.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.movie, color: Colors.white30, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How was Interstellar?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text("Movie night on May 3", style: TextStyle(color: AppColors.white, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: List.generate(5, (index) => const Icon(Icons.star_border_rounded, color: Colors.white30, size: 18)),
              ),
              const SizedBox(height: 4),
              const Text("Add Note", style: TextStyle(color: AppColors.softPeriwinkle, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

class _WatchlistGrid extends StatelessWidget {
  final List<Movie> movies;

  const _WatchlistGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          alignment: Alignment.center,
          child: const Text(
            "Your watchlist is empty.",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, 
        childAspectRatio: 2 / 3, 
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return MovieCard(item: movies[index]); 
        },
        childCount: movies.length, 
      ),
    );
  }
}