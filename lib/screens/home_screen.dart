import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MovieITApp());
}

class MovieITApp extends StatelessWidget {
  const MovieITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeCategory = 'Home';
  final ScrollController _trendingScrollController = ScrollController();
  
  late PageController _heroPageController;
  int _currentHeroPage = 0;

  final List<Map<String, String>> _heroItems = [
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
  void initState() {
    super.initState();
    _heroPageController = PageController(viewportFraction: 0.7, initialPage: 0);
  }

  void _onNavTap(String category) {
    setState(() => _activeCategory = category);
  }

  @override
  void dispose() {
    _trendingScrollController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomNavBar(activeCategory: _activeCategory, onTap: _onNavTap),
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 180),
                _buildHeroSection(),
                const SizedBox(height: 30),
                _buildPageIndicators(),
                const SizedBox(height: 60),
                _buildTrendingSection(),
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

  Widget _buildHeroSection() {
    return SizedBox(
      height: 500,
      child: PageView.builder(
        controller: _heroPageController,
        itemCount: _heroItems.length,
        onPageChanged: (int page) => setState(() => _currentHeroPage = page),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _heroPageController,
            builder: (context, child) {
              double value = 1.0;
              if (_heroPageController.position.haveDimensions) {
                value = _heroPageController.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
              } else {
                value = index == 0 ? 1.0 : 0.8;
              }
              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.5, 1.0),
                    child: child,
                  ),
                ),
              );
            },
            child: _buildHeroCard(_heroItems[index]),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Color(int.parse(item['color']!)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned(
              right: -30, bottom: -20,
              child: Icon(Icons.movie_creation_outlined, size: 300, color: Colors.white.withOpacity(0.05)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['title']!,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(item['rating']!, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 15),
                      Text(item['year']!, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 15),
                      _buildTag('R'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 450,
                    child: Text(
                      item['desc']!,
                      style: const TextStyle(color: Colors.white60, fontSize: 17, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      _buildActionBtn('Play', Icons.play_arrow, const Color(0xFFAC66FF)),
                      const SizedBox(width: 15),
                      _buildActionBtn('More Info', Icons.info_outline, Colors.white12),
                      const SizedBox(width: 15),
                      _buildActionBtn('Save', Icons.bookmark_border, const Color(0xFF2D2D3A)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_heroItems.length, (index) {
        bool isActive = index == _currentHeroPage;
        return GestureDetector(
          onTap: () {
            _heroPageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutQuart,
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: isActive ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTrendingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trending in $_activeCategory", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          RawScrollbar(
            controller: _trendingScrollController,
            thumbColor: const Color(0xFF9D4EDD),
            radius: const Radius.circular(10),
            thickness: 4,
            thumbVisibility: true,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                controller: _trendingScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  width: 350,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white10,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.movie_filter, color: Colors.white24, size: 50),
                        const SizedBox(height: 10),
                        Text("Movie $index for $_activeCategory"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: Colors.white38), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String activeCategory;
  final Function(String) onTap;

  const CustomNavBar({
    super.key,
    required this.activeCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "MovieIT", 
              style: GoogleFonts.bagelFatOne(color: Colors.white, fontSize: 20)
            ),
            _buildGlassNavPill(),
            IconButton(
              icon: const Icon(Icons.dark_mode, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGlassNavPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0x33C3B1E1), 
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x33FFFFFF), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              IconButton(
                
                icon: Icon(Icons.home, color: activeCategory == 'Home' ? const Color(0xFFAC66FF) : Colors.white), 
                onPressed: () => onTap('Home'),
              ),
              const SizedBox(width: 40), 
              IconButton(
           
                icon: Icon(Icons.search, color: activeCategory == 'Search' ? const Color(0xFFAC66FF) : Colors.white),
                onPressed: () => onTap('Search'),
              ),
              const SizedBox(width: 40),
              IconButton(
               
                icon: Icon(Icons.bookmark_border, color: activeCategory == 'Watchlist' ? const Color(0xFFAC66FF) : Colors.white), 
                onPressed: () => onTap('Watchlist'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}