import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/movie_models.dart';
import 'package:go_router/go_router.dart';
import 'landscape_movie_card.dart';

class SimilarMoviesSection extends StatefulWidget {
  final List<Movie> movies;
  
  const SimilarMoviesSection({super.key, required this.movies});

  @override
  State<SimilarMoviesSection> createState() => _SimilarMoviesSectionState();
}

class _SimilarMoviesSectionState extends State<SimilarMoviesSection> {
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
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(label: 'More Like This'),
        const SizedBox(height: 20),
        
        SizedBox(
            height: 260, 
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ListView.builder(
                  clipBehavior: Clip.none,
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 25),
                  itemCount: widget.movies.length, 
                  itemBuilder: (context, index) {
                    return LandscapeMovieCard(item: widget.movies[index]);
                  },
                ),
            
                if (_showLeftArrow) Positioned(
                  left: -20,
                  child: _buildNavArrow(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => _scrollBy(-800), 
                  ),
                ),

                if (_showRightArrow) Positioned(
                  right: -20,
                  child: _buildNavArrow(
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () => _scrollBy(800),
                  ),
                ),
              ],
            ),
          ),
      ],
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

class _SectionHeading extends StatelessWidget {
  final String label;
  const _SectionHeading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFFE53935), width: 3),
        ),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}