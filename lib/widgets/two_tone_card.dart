import 'package:flutter/material.dart';

class TwoToneCard extends StatelessWidget {
  final String? title;
  final Widget? customTitle; 
  final String? trailing;
  final Widget? customTrailing;
  final Widget child;

  const TwoToneCard({
    super.key,
    this.title,
    this.customTitle,
    this.trailing,
    this.customTrailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBodyColor = Color(0xFF1E1E1E);
    const Color cardHeaderColor = Color(0xFF1D2440);

    return Container(
      decoration: BoxDecoration(
        color: cardBodyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: cardHeaderColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTitle ?? Text(
                  title ?? '',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                customTrailing ?? (trailing != null 
                    ? Text(trailing!, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)) 
                    : const SizedBox.shrink()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}