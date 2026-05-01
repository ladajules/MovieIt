import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:go_router/go_router.dart';

class MovieCard extends StatefulWidget {
  final Movie item;


  const MovieCard({
    super.key,
    required this.item,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
      Logger log = Logger();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          log.d("Movie card tapped");
          context.push('/movie/${widget.item.id}');
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            margin: const EdgeInsets.only(right: 20), 
            child: AspectRatio(
              aspectRatio: 2 / 3, 
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.item.posterUrl ?? 'https://via.placeholder.com/400x600?text=No+Poster'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
          ),
        )
      ),
    );
    
   
  }
}