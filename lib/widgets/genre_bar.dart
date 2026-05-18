import 'package:flutter/material.dart';

class GenreBar extends StatelessWidget {
  final String genre;
  final double percentage;

  const GenreBar({
    super.key, 
    required this.genre, 
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFAC66FF);

    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            genre, 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 13, 
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Container(
                    height: 4,
                    width: constraints.maxWidth * (percentage / 100),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 35,
          child: Text(
            "${percentage.toInt()}%", 
            style: const TextStyle(color: Colors.white70, fontSize: 12), 
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}