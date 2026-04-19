import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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