import 'package:flutter/material.dart';
import '../widgets/hero_slider.dart';
import '../widgets/horizontal_movie_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  dummy data 
  final List<Map<String, String>> _dummyHeroItems = [
    {
      "title": "Ako Ay Mayroong Alagang Aso",
      "desc": "A heartwarming tale about a man and his dog driving through Cubao. Beep beep beep.",
      "rating": "7.0", "year": "2026", "color": "0xFF1A1A2E"
    },
    {
      "title": "The Midnight Express",
      "desc": "A thrilling journey through the neon-lit streets of a futuristic city. Time is running out.",
      "rating": "8.5", "year": "2025", "color": "0xFF2E1A1A"
    },
    {
      "title": "Silence of the Stars",
      "desc": "An astronaut's solo mission to the edge of the galaxy takes a mysterious turn.",
      "rating": "9.2", "year": "2027", "color": "0xFF1A2E1A"
    },
    {
      "title": "Cyber City 2077",
      "desc": "In a world of machines, one man discovers what it truly means to be human.",
      "rating": "8.8", "year": "2028", "color": "0xFF2E2E1A"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 180),
                
                //  hero Slider
                HeroSlider(movies: _dummyHeroItems),
                
                const SizedBox(height: 60),
                
                //  horizontal List
                HorizontalMovieList(sectionTitle: "Trending Now"),
                
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
        ),
      ),
    );
  }
}