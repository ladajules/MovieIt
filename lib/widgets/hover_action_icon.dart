import 'package:flutter/material.dart';

class HoverActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HoverActionIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  State<HoverActionIcon> createState() => _HoverActionIconState();
}

class _HoverActionIconState extends State<HoverActionIcon> {
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