import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieit/models/movie_models.dart';

class HeroSlider extends StatefulWidget {
  final List<Movie> movies;

  const HeroSlider({super.key, required this.movies});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  late PageController _heroPageController;
  int _currentHeroPage = 0;

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController(viewportFraction: 0.7, initialPage: 0);
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _heroPageController,
            itemCount: widget.movies.length,
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
                child: _buildHeroCard(widget.movies[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        _buildPageIndicators(),
      ],
    );
  }

  Widget _buildHeroCard(Movie item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: NetworkImage(item.backdropUrl ?? item.posterUrl ?? 'https://via.placeholder.com/800x500'),
          fit: BoxFit.cover,
        ),
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
                    item.title,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(item.rating ?? 'N/A', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 15),
                      Text(item.year ?? 'N/A', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 15),
                      _buildTag('R'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 450,
                    child: Text(
                      item.overview,
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
      children: List.generate(widget.movies.length, (index) {
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