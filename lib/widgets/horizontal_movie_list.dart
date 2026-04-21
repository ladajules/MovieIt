import 'package:flutter/material.dart';
import 'movie_card_horizontal.dart';

class HorizontalMovieList extends StatefulWidget {
  final String sectionTitle;
  
  const HorizontalMovieList({super.key, required this.sectionTitle});

  @override
  State<HorizontalMovieList> createState() => _HorizontalMovieListState();
}

class _HorizontalMovieListState extends State<HorizontalMovieList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sectionTitle, 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
          ),
          const SizedBox(height: 20),
          RawScrollbar(
            controller: _scrollController,
            thumbColor: const Color(0xFF9D4EDD),
            radius: const Radius.circular(10),
            thickness: 4,
            thumbVisibility: true,
            child: SizedBox(
              height: 280, 
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return MovieCard(
                    title: "Movie Title ${index + 1}",
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}