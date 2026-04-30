import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:go_router/go_router.dart';

class MovieCard extends StatelessWidget {
  final Movie item;


  const MovieCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
      Logger log = Logger();
    return GestureDetector(
      onTap: (){
        log.d("Movie card tapped");
        context.push('/movie/${item.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20), 
        child: AspectRatio(
          aspectRatio: 2 / 3, 
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(item.posterUrl ?? 'https://via.placeholder.com/400x600?text=No+Poster'),
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
      )
    );
    
   
  }
}