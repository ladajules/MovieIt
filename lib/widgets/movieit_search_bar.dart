import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieit/theme/app_colors.dart';

class MovieItSearchBar extends StatefulWidget {
    final ValueChanged<String>? onChanged;
    final String hintText;

  const MovieItSearchBar({super.key, this.onChanged, this.hintText = 'Search movies by title...'});

  @override
  State<MovieItSearchBar> createState() => _MovieItSearchBarState();
}

class _MovieItSearchBarState extends State<MovieItSearchBar> {
    final _controller = TextEditingController();

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.5),
          ),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: const TextStyle(color: AppColors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 15),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
              suffixIcon: _controller.text.isNotEmpty ? IconButton(
                icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.5), size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                  setState(() {});
                },
              ) : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onTap: () => setState(() {}),
          ),
        ),
      ),
    );
  }
}
