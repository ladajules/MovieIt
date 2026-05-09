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
    return Container(
        height: 48,
        margin: const EdgeInsets.only(left: 14, right: 34),
        decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(32),        
            border: Border.all(color: AppColors.softPeriwinkle, width: 2),
        ),
        child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: const TextStyle(color: AppColors.white, fontSize: 15),
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: AppColors.charcoal, fontSize: 15),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.charcoal, size: 20),
                suffixIcon: _controller.text.isNotEmpty ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.charcoal, size: 18),
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
    );
  }
}