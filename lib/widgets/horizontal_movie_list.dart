import 'package:flutter/material.dart';
import 'package:movieit/models/movie_models.dart';
import 'movie_card_horizontal.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalMovieList extends StatefulWidget {
  final List<Movie> movies;
  final String sectionTitle;
  
  const HorizontalMovieList({super.key, required this.movies, required this.sectionTitle});

  @override
  State<HorizontalMovieList> createState() => _HorizontalMovieListState();
}

class _HorizontalMovieListState extends State<HorizontalMovieList> {
  final ScrollController _scrollController = ScrollController();

  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final showLeft = position.pixels > 0;
    final showRight = position.pixels < position.maxScrollExtent;

    if (_showLeftArrow != showLeft || _showRightArrow != showRight) {
      setState(() {
        _showLeftArrow = showLeft;
        _showRightArrow = showRight;
      });
    }
  }

  void _scrollBy(double offset) {
    if (!_scrollController.hasClients) return;

    final targetPosition = (_scrollController.offset + offset).clamp(
      _scrollController.position.minScrollExtent, 
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetPosition, 
      duration: const Duration(milliseconds: 600), 
      curve: Curves.easeOutCubic
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sectionTitle,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.1),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 380, 
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ListView.builder(
                  clipBehavior: Clip.none,
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return MovieCard(
                    item: widget.movies[index], 
                    );
                  },
                ),
            
                if (_showLeftArrow) Positioned(
                  left: -20,
                  child: _buildNavArrow(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => _scrollBy(-700),
                  ),
                ),

                if (_showRightArrow) Positioned(
                  right: -20,
                  child: _buildNavArrow(
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () => _scrollBy(700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavArrow({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.6),
            border: Border.all(color: Colors.white24, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

