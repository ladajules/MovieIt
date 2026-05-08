import 'package:flutter/material.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';
import 'package:intl/intl.dart';

class MonthlyGoalCard extends StatelessWidget {
  const MonthlyGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = 2 / 4;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.plannerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Goal', style: AppStyles.heading(size: 14)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '2',
                      style: AppStyles.value(size: 14, color: AppColors.softPeriwinkle),
                    ),
                    TextSpan(
                      text: ' / 4',
                      style: AppStyles.body(size: 14, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.dividerSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.softPeriwinkle),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You are on track — 2 more nights to hit your ${DateFormat('MMMM').format(DateTime.now())} goal.',
            style: AppStyles.body(size: 11),
          ),
        ],
      ),
    );
  }
}