import 'package:flutter/material.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';
import '../models/scheduled_event.dart';
import '../services/local_db_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/stats_engine.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: LocalDbService().listenToEvents(),
      builder: (context, box, _) {
        final engine = StatsEngine(box);
        final streak = engine.getWeeklyStreak();
        
        final personalBest = streak > 5 ? streak : 5; // TODO: actual PB soon

        Color themeColor;
        Color bgColor;
        Color borderColor;
        IconData icon;
        String titleText;

        if (streak == 0) {
          themeColor = AppColors.textMuted;
          bgColor = AppColors.plannerSurface;
          borderColor = AppColors.cardBorder;
          icon = Icons.local_fire_department_outlined;
          titleText = 'Start a Streak!';
        } else if (streak < 3) {
        
          themeColor = const Color(0xFF38BDF8); 
          bgColor = const Color(0xFF0C2B3B);
          borderColor = const Color(0xFF164E63);
          icon = Icons.ac_unit_rounded;
          titleText = '$streak Week Streak!';
        } else {
          themeColor = const Color(0xFFE8720C); 
          bgColor = const Color(0xFF2E1A08);
          borderColor = const Color(0xFF7A3A08);
          icon = Icons.local_fire_department_rounded;
          titleText = '$streak Week Streak!';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.plannerCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: streak > 0 
                ? [BoxShadow(color: themeColor.withOpacity(0.20), blurRadius: 18, offset: const Offset(0, 2))] 
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(icon, color: themeColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(titleText, style: AppStyles.heading(size: 14)),
              ),
              Text('Personal best: $personalBest', style: AppStyles.body(size: 11)),
            ],
          ),
        );
      },
    );
  }
}