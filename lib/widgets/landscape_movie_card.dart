import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class LandscapeMovieCard extends StatefulWidget {
  final Movie item;

  const LandscapeMovieCard({super.key, required this.item});

  @override
  State<LandscapeMovieCard> createState() => _LandscapeMovieCardState();
}

class _LandscapeMovieCardState extends State<LandscapeMovieCard> {
  bool _isHovered = false;
  static final Logger _log = Logger();

  String get _year {
    final date = widget.item.year ?? '';
    return date.length >= 4 ? date.substring(0, 4) : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _log.d("Movie card tapped: ${widget.item.title}");
          context.push('/movie/${widget.item.id}');
        },
        child: Container(
          width: 260, 
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Container(
                  height: 146, 
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      if (_isHovered)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(widget.item.backdropUrl ?? 'https://via.placeholder.com/500x281?text=No+Image'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                widget.item.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _isHovered ? AppColors.accentDim : Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.accentDim, size: 12), 
                  const SizedBox(width: 4),
                  Text(
                    (widget.item.rating ?? 0.0).toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  _buildDotSeparator(),
                  Text(
                    _year,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('·', style: TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}