import 'package:flutter/material.dart';

// I renamed the class to match the filename perfectly!
class MovieCard extends StatelessWidget {
  final String title;

  const MovieCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // Back to your original wide layout
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white10, // Your original background color
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_filter, color: Colors.white24, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}