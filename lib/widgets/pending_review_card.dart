import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.plannerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: 56,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4A1A7A), Color(0xFF1A1A4A)]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.movie_creation_outlined, color: Colors.white30, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('How was Interstellar?', style: AppStyles.heading(size: 14)),
              const SizedBox(height: 4),
              Text('Movie night on May 3', style: AppStyles.body(size: 12)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(5, (i) => const Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.star_border_rounded, color: Color(0xFF5A5A7A), size: 20))),
            const SizedBox(width: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text('Add Note', style: AppStyles.body(size: 12, color: AppColors.softPeriwinkle)),
            ),
          ],
        ),
      ]),
    );
  }
}