import 'package:flutter/material.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  static const _orange = Color(0xFFE8720C);
  static const _orangeBg = Color(0xFF2E1A08);
  static const _orangeBorder = Color(0xFF7A3A08);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.plannerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _orangeBorder),
        boxShadow: [
          BoxShadow(
            color: _orange.withOpacity(0.20),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _orangeBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _orangeBorder),
            ),
            child: const Icon(Icons.local_fire_department_rounded, color: _orange, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '5 Week\nStreak!',
              style: AppStyles.heading(size: 14),
            ),
          ),
          Text(
            'Personal best: 8',
            style: AppStyles.body(size: 11),
          ),
        ],
      ),
    );
  }
}