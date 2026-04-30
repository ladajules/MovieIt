import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/movie_details_model.dart';

class MovieHeroSection extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback? onAddToWatchlist;
  final bool isInWatchlist;

  const MovieHeroSection({
    super.key,
    required this.movie,
    this.onAddToWatchlist,
    this.isInWatchlist = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isWide = screenWidth > 900;

    return SizedBox(
      height: isWide ? 520 : null,
      child: Stack(
        children: [
          _BackdropImage(url: movie.backdropUrl),

          const _GradientOverlay(),

          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 60 : 24,
                vertical: isWide ? 40 : 24,
              ),
              child: isWide
                  ? _WideLayout(movie: movie, onAddToWatchlist: onAddToWatchlist, isInWatchlist: isInWatchlist)
                  : _NarrowLayout(movie: movie, onAddToWatchlist: onAddToWatchlist, isInWatchlist: isInWatchlist),
            ),
          ),
        ],
      ),
    );
  }
}


class _BackdropImage extends StatelessWidget {
  final String? url;
  const _BackdropImage({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Container(color: const Color(0xFF1A1A1A));
    }
    return Positioned.fill(
      child: Image.network(
        url!,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, _) =>
            frame == null ? Container(color: const Color(0xFF1A1A1A)) : child,
        errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.85),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback? onAddToWatchlist;
  final bool isInWatchlist;
  const _WideLayout({required this.movie, this.onAddToWatchlist, required this.isInWatchlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end, 
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 6,
              child: _InfoColumn(movie: movie, onAddToWatchlist: onAddToWatchlist, isInWatchlist: isInWatchlist),
            ),
            const SizedBox(width: 40),
            SizedBox(
              width: 220,
              child: _MetadataPanel(movie: movie),
            ),
          ],
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback? onAddToWatchlist;
  final bool isInWatchlist;
  const _NarrowLayout({required this.movie, this.onAddToWatchlist, required this.isInWatchlist});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          _InfoColumn(movie: movie, onAddToWatchlist: onAddToWatchlist, isInWatchlist: isInWatchlist),
          const SizedBox(height: 24),
          _MetadataPanel(movie: movie),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback? onAddToWatchlist;
  final bool isInWatchlist;
  const _InfoColumn({required this.movie, this.onAddToWatchlist, required this.isInWatchlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          movie.title.toUpperCase(),
          style: GoogleFonts.bagelFatOne(
            fontSize: 42,
            color: Colors.white,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 6),

        Text(
          movie.genres.join(' • '),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 20),

        _WatchlistButton(
          isInWatchlist: isInWatchlist,
          onTap: onAddToWatchlist,
        ),
        const SizedBox(height: 24),

        _StatsRow(movie: movie),
        const SizedBox(height: 8),

        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Director: ',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              TextSpan(
                text: movie.director,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            movie.overview,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _WatchlistButton extends StatelessWidget {
  final bool isInWatchlist;
  final VoidCallback? onTap;
  const _WatchlistButton({required this.isInWatchlist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isInWatchlist ? const Color(0xFFA970FF) : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_add_outlined,
                  color: isInWatchlist ? Colors.white : Colors.black,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isInWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                  style: TextStyle(
                    color: isInWatchlist ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final MovieDetails movie;
  const _StatsRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statText(movie.year ?? 'N/A'),
        _dot(),
        _statText(movie.formattedRuntime),
        const SizedBox(width: 10),
        _CertChip(label: movie.certification),
        const SizedBox(width: 10),
        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        _statText(movie.rating ?? '0.0'),
      ],
    );
  }

  Widget _statText(String t) => Text(
        t ?? 'N/A', 
        style: const TextStyle(color: Colors.white),
      );

  Widget _dot() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('·', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
}

class _CertChip extends StatelessWidget {
  final String label;
  const _CertChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}

class _MetadataPanel extends StatelessWidget {
  final MovieDetails movie;
  const _MetadataPanel({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(label: 'Runtime', value: '${movie.formattedRuntime}'),
          _MetaRow(label: 'Language', value: movie.language),
          if (movie.releaseDate != null)
            _MetaRow(label: 'Release Date', value: movie.releaseDate!),
          if (movie.budget != null && movie.budget != r'$0')
            _MetaRow(label: 'Budget', value: movie.budget!),
          if (movie.revenue != null && movie.revenue != r'$0')
            _MetaRow(label: 'Revenue', value: movie.revenue!),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}