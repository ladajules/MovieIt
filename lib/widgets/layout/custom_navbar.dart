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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'icons/popcorn_icon.png',
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 10,),
              
                  Text(
                    "MovieIT", 
                    style: GoogleFonts.bagelFatOne(color: Colors.white, fontSize: 20)
                  ),
                ],
              ),
            ),

            _buildGlassNavPill(),

            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HoverActionIcon(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      /// TODO: pop-up modal showing notifications
                    },
                  ),
                  const SizedBox(width: 6,),
                  
                  _HoverActionIcon(
                    icon: Icons.settings_rounded,
                    onTap: () {
                      /// TODO: pop-up modal showing settings? 
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGlassNavPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withOpacity(0.65), //0x33C3B1E1
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              _GlassNavItem(
                icon: Icons.home_rounded, 
                isActive: activeCategory == 'Home',
                onTap: () => onTap('Home'),
              ),
              const SizedBox(width: 20,),

              _GlassNavItem(
                icon: Icons.search_rounded, 
                isActive: activeCategory == 'Search',
                onTap: () => onTap('Search'),
              ),
              const SizedBox(width: 20,),
              
              _GlassNavItem(
                icon: Icons.bookmark_border_rounded, 
                isActive: activeCategory == 'Watchlist',
                onTap: () => onTap('Watchlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _GlassNavItem extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _GlassNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_GlassNavItem> createState() => _GlassNavItemState();
}

class _GlassNavItemState extends State<_GlassNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? const Color(0xFFAC66FF).withOpacity(0.2) 
                : (_isHovered ? const Color(0xFFAC66FF).withOpacity(0.2) : Colors.transparent),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: widget.isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isActive || _isHovered ? Color(0xFFAC66FF) : Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HoverActionIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_HoverActionIcon> createState() => _HoverActionIconState();
}

class _HoverActionIconState extends State<_HoverActionIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(10), 
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? const Color(0xFFAC66FF).withOpacity(0.2) : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? Color(0xFFAC66FF) : Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}