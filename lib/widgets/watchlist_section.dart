import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/local_db_service.dart';
import '../../models/watchlist_item.dart';
import '../../models/user_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../widgets/universal_banner.dart';

class WatchlistSection extends StatelessWidget {
  const WatchlistSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Watchlist', style: AppStyles.heading(size: 20)),
            _PillButton(label: '+ Add', onTap: () => context.go('/search')),
          ],
        ),
        const SizedBox(height: 14),
        
        ValueListenableBuilder<Box<WatchlistItem>>(
          valueListenable: LocalDbService().listenToWatchlist(),
          builder: (context, box, _) {
            final movies = box.values.toList()
              ..sort((a, b) => b.cachedAt.compareTo(a.cachedAt));

            if (movies.isEmpty) {
              return const _EmptyWatchlistState();
            }

            return LayoutBuilder(builder: (ctx, c) {
              final cols = c.maxWidth > 500 ? 4 : 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: movies.map((m) {
                  final w = (c.maxWidth - (cols - 1) * 12) / cols;
                  return _WatchlistCard(movie: m, width: w);
                }).toList(),
              );
            });
          },
        ),
      ],
    );
  }
}

class _EmptyWatchlistState extends StatelessWidget {
  const _EmptyWatchlistState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.plannerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.movie_creation_outlined, color: AppColors.softPeriwinkle, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: AppStyles.heading(size: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for movies to build your backlog and schedule future movie nights.',
            style: AppStyles.body(size: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WatchlistCard extends StatefulWidget {
  final WatchlistItem movie;
  final double width;
  const _WatchlistCard({required this.movie, required this.width});

  @override
  State<_WatchlistCard> createState() => _WatchlistCardState();
}

class _WatchlistCardState extends State<_WatchlistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (widget.movie.posterPath.isNotEmpty) {
      if (widget.movie.posterPath.startsWith('http')) {
        imageUrl = widget.movie.posterPath;
      } else {
        const kTmdbImageBase = 'https://image.tmdb.org/t/p/';
        const kPosterSize = 'w342';
        final safePath = widget.movie.posterPath.startsWith('/')
            ? widget.movie.posterPath
            : '/${widget.movie.posterPath}';
        imageUrl = '$kTmdbImageBase$kPosterSize$safePath';
      }
    }

    String formattedRuntime = '0 min';
    if (widget.movie.runtimeMinutes > 0) {
      final hours = widget.movie.runtimeMinutes ~/ 60;
      final minutes = widget.movie.runtimeMinutes % 60;
      formattedRuntime = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
    }

    return SizedBox(
      width: widget.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: Stack(
            children: [
              Container(
                height: widget.width * 1.4,
                decoration: BoxDecoration(
                  color: AppColors.plannerSurface,
                  borderRadius: BorderRadius.circular(10),
                  image: imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: imageUrl == null
                    ? const Center(child: Icon(Icons.movie, color: AppColors.textMuted))
                    : null,
              ),
              if (_isHovered)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      await LocalDbService().toggleWatchlist(widget.movie);
                      if (context.mounted) {
                        final prefsBox = Hive.box<UserPreferences>('user_preferences');
                        final prefs = prefsBox.get('current_prefs');
                        if (prefs != null && prefs.notificationsEnabled) {
                          UniversalBanner.show(
                            context: context,
                            title: 'Removed from Watchlist',
                            subTitle: '${widget.movie.title} removed from your list.',
                            imageUrl: widget.movie.posterPath,
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          widget.movie.title,
          style: AppStyles.body(size: 12, color: AppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(formattedRuntime, style: AppStyles.body(size: 11)),
      ]),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.plannerSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Text(label, style: AppStyles.body(size: 12, color: AppColors.white)),
        ),
      ),
    );
  }
}