import 'package:flutter/material.dart';
import 'package:movieit/models/user_stats.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';
import 'package:intl/intl.dart';

import '../models/scheduled_event.dart';
import '../services/local_db_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/stats_engine.dart';

class MonthlyGoalCard extends StatelessWidget {
  const MonthlyGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserStats>>(
      valueListenable: Hive.box<UserStats>('user_stats').listenable(),
      builder: (context, statsBox, _) {
        final stats = statsBox.get('user_stats') ?? UserStats();
        final eventsBox = Hive.box<ScheduledEvent>('scheduled_event');

        final engine = StatsEngine(eventsBox, stats);
        final current = engine.getCurrentMonthProgress();
        
        final target = 4;
        
        final progress = (current / target).clamp(0.0, 1.0);
        final isComplete = current >= target;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.plannerCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isComplete ? AppColors.successGreen.withOpacity(0.4) : AppColors.cardBorder,
            ),
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
                          text: '$current', 
                          style: AppStyles.value(size: 14, color: isComplete ? AppColors.successGreen : AppColors.softPeriwinkle)
                        ),
                        TextSpan(text: ' / $target', style: AppStyles.body(size: 14, color: AppColors.textMuted)),
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? AppColors.successGreen : AppColors.softPeriwinkle
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                isComplete 
                    ? 'Goal reached! Amazing job.' 
                    : '${target - current} more nights to hit your ${DateFormat('MMMM').format(DateTime.now())} goal.',
                style: AppStyles.body(size: 11, color: isComplete ? AppColors.successGreen : AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}