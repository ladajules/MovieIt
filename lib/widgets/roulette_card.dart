import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class RouletteCard extends StatelessWidget {
  const RouletteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2D1060), Color(0xFF1A0840)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4A1A8A)),
      ),
      child: Column(children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
          child: const Icon(Icons.casino_outlined, color: AppColors.softPeriwinkle, size: 22),
        ),
        const SizedBox(height: 12),
        Text("Can't Decide?", style: AppStyles.heading(size: 15)),
        const SizedBox(height: 6),
        Text('Spin the roulette and let MovieIT pick from your watchlist.', style: AppStyles.body(size: 12), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.softPeriwinkle,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Pick For Me', style: AppStyles.heading(size: 14, color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}