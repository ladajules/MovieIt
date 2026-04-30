

import 'package:flutter/material.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:movieit/widgets/movie_card_horizontal.dart';

class SearchResultGrid extends StatefulWidget{
  final List<Movie> movies;
  const SearchResultGrid({super.key, required this.movies});

  @override
  State<SearchResultGrid> createState() => _SearchResultGridState();
}



class _SearchResultGridState extends State<SearchResultGrid> {

    @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:  const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:  widget.movies.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, //number of items per row        
        crossAxisSpacing: 16,      
        mainAxisSpacing: 16,       
        childAspectRatio: 0.65, 
      ),

      itemBuilder: (context, index){
        return MovieCard(item: widget.movies[index]);
      }
    );

  }

}

