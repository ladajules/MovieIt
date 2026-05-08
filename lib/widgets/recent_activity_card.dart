import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'surface_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../models/scheduled_event.dart';
import '../services/local_db_service.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: LocalDbService().listenToEvents(),
      builder: (context, box, _) {
        final completedEvents = box.values.where((e) => e.isReviewed).toList();
        
        completedEvents.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
        
        final recentActivity = completedEvents.take(4).toList();

        return SurfaceCard(
          headerLeft: Text('Recent Activity', style: AppStyles.heading(size: 14)),
          body: recentActivity.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.history_toggle_off_rounded, color: AppColors.textMuted, size: 28),
                        const SizedBox(height: 8),
                        Text('No activity yet.', style: AppStyles.body()),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: recentActivity.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: AppColors.softPeriwinkle, size: 13),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Text(event.movieTitle, style: AppStyles.body(size: 13, color: AppColors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                                '${_formatDate(event.scheduledDate)} · ${event.rating?.toStringAsFixed(1) ?? '0.0'} Stars', 
                                style: AppStyles.body(size: 11)
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);
    
    if (aDate == today) return 'Today';
    if (aDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    
    return DateFormat('MMM d').format(date);
  }
}