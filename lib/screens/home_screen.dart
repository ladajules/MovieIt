import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CRITICAL FIX 1: This pushes the gradient up underneath the glass nav bar
      extendBodyBehindAppBar: true, 
      appBar: const CustomNavBar(),
      
      // CRITICAL FIX 2: A vibrant background so the blur actually has something to blur
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Deep purple
              Colors.black,
              Color(0xFF0D47A1), // Deep blue
            ],
          ),
        ),
        child: const SafeArea(
          child: Center(
            child: Text(
              'Welcome to MovieIT',
              style: TextStyle(color: Colors.white, fontSize: 20)
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Architecture alignment
             Text(
              "MovieIT", 
              style: GoogleFonts.bagelFatOne(color: Colors.white, fontSize: 20)
            ),
            _buildGlassNavPill(),
            IconButton(
              // CRITICAL FIX 3: White icon for contrast
              icon: const Icon(Icons.dark_mode, color: Colors.white),
              onPressed: () {
                // theme toggle
              },
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
            // Using the baked-in 20% opacity hex code (0x33) we discussed
            color: const Color(0x33C3B1E1), 
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x33FFFFFF), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              IconButton(
                // CRITICAL FIX 3: White icons for contrast
                icon: const Icon(Icons.home, color: Colors.white), 
                onPressed: () {},
              ),
              const SizedBox(width: 40), 
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white), 
                onPressed: () {},
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