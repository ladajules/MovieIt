import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_models.dart';

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
      },
      child:  Container(
              width: 160, 
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(item.posterUrl ?? 'https://via.placeholder.com/500x750'),
                  fit: BoxFit.cover,
                )
              ),
            )
    );
    
   
  }
}