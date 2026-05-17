import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../services/local_db_service.dart';
import '../models/watchlist_item.dart';
import '../models/movie_details_model.dart';
import '../widgets/schedule_movie_modal.dart';
import '../utils/tmdb_image_helper.dart';

class RouletteCard extends StatefulWidget {
  const RouletteCard({super.key});

  @override
  State<RouletteCard> createState() => _RouletteCardState();
}

class _RouletteCardState extends State<RouletteCard> {
  bool _isSpinning = false;
  WatchlistItem? _selectedItem;
  WatchlistItem? _shufflingItem;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _spinRoulette() {
    final box = LocalDbService().listenToWatchlist().value;
    final items = box.values.toList();

    if (items.isEmpty) {
      // TODO: notif saying watchlist is empty.
      return;
    }

    setState(() {
      _isSpinning = true;
      _selectedItem = null;
    });

    final random = Random();
    int ticks = 0;
    const maxTicks = 20; 

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _shufflingItem = items[random.nextInt(items.length)];
      });

      ticks++;
      if (ticks >= maxTicks) {
        timer.cancel();
        setState(() {
          _isSpinning = false;
          _selectedItem = items[random.nextInt(items.length)];
        });
      }
    });
  }

  void _openScheduleModal(WatchlistItem item) {
    final resolvedPosterUrl = TmdbImageHelper.buildUrl(item.posterPath);
    final localMovie = MovieDetails(
      id: item.tmdbId,
      title: item.title,
      overview: 'Overview not available in watchlist cache.', 
      posterUrl: resolvedPosterUrl,
      backdropUrl: resolvedPosterUrl,
      year: 'Unknown', 
      rating: 'N/A', 
      director: 'Unknown',    
      certification: 'NR',   
      language: 'EN',            
      cast: const [],      
      genres: item.genreIds.map((id) => id.toString()).toList(), 
      runtime: item.runtimeMinutes,
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => ScheduleMovieModal(movie: localMovie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
          colors: [Color(0xFF2D1060), Color(0xFF1A0840)]
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4A1A8A)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentState(),
      ),
    );
  }

  Widget _buildCurrentState() {
    if (_isSpinning && _shufflingItem != null) {
      return _SpinningState(item: _shufflingItem!);
    } else if (_selectedItem != null) {
      return _ResultState(
        item: _selectedItem!,
        onSchedule: () => _openScheduleModal(_selectedItem!),
        onSpinAgain: _spinRoulette,
      );
    } else {
      return _DefaultState(onSpin: _spinRoulette);
    }
  }
}

class _DefaultState extends StatelessWidget {
  final VoidCallback onSpin;
  const _DefaultState({required this.onSpin});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('default'),
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
          child: const Icon(Icons.casino_outlined, color: AppColors.softPeriwinkle, size: 22),
        ),
        const SizedBox(height: 12),
        Text("Can't Decide?", style: AppStyles.heading(size: 15)),
        const SizedBox(height: 6),
        Text(
          'Spin the roulette and let MovieIT pick from your watchlist.', 
          style: AppStyles.body(size: 12), 
          textAlign: TextAlign.center
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSpin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPeriwinkle,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Pick For Me', style: AppStyles.heading(size: 14, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _SpinningState extends StatelessWidget {
  final WatchlistItem item;
  const _SpinningState({required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey('spinning_${item.tmdbId}'), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(TmdbImageHelper.buildUrl(item.posterPath, size: 'w185')),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Shuffling...', style: AppStyles.heading(size: 14, color: AppColors.softPeriwinkle)),
        ],
      ),
    );
  }
}

class _ResultState extends StatelessWidget {
  final WatchlistItem item;
  final VoidCallback onSchedule;
  final VoidCallback onSpinAgain;

  const _ResultState({
    required this.item,
    required this.onSchedule,
    required this.onSpinAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('result'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MovieIT Picked:', style: AppStyles.label(color: AppColors.softPeriwinkle)),
            GestureDetector(
              onTap: onSpinAgain,
              child: const Icon(Icons.refresh_rounded, color: AppColors.wisteria, size: 18),
            )
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(TmdbImageHelper.buildUrl(item.posterPath, size: 'w185')),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppStyles.heading(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${item.runtimeMinutes} mins', style: AppStyles.body(size: 11)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                      const SizedBox(width: 4),
                      Text('TBD', style: AppStyles.body(size: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSchedule,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPeriwinkle,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Schedule Now', style: AppStyles.heading(size: 14, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
