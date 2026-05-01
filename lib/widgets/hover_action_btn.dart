import 'package:flutter/material.dart';

class HoverActionBtn extends StatefulWidget {
    final String label;
    final IconData icon;
    final Color baseColor;
    final VoidCallback onTap;

    const HoverActionBtn({
        super.key,
        required this.label,
        required this.icon,
        required this.baseColor,
        required this.onTap,
    });

    @override
    State<HoverActionBtn> createState() => _HoverActionBtnState();
}

class _HoverActionBtnState extends State<HoverActionBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFFAC66FF) : widget.baseColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: _isHovered
                  ? [BoxShadow(color: const Color(0xFFAC66FF).withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



