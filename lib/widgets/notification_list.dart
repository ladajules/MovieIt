
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/utils/tmdb_image_helper.dart';

class NotificationList extends StatelessWidget{
  const NotificationList({super.key});
    @override
    Widget build(BuildContext context) {
      return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: Hive.box<ScheduledEvent>('scheduled_event').listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();

        final upcomingEvents = box.values.where((event){
          final difference =  event.scheduledDate.difference(now);
          return !difference.isNegative && difference.inHours <= 24;
        }).toList();

        upcomingEvents.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

        if (upcomingEvents.isEmpty){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 48,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No upcoming movies in the next 24 hours.\nTime to plan something!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          separatorBuilder: (context, index) => const Divider(color: AppColors.dividerSubtle, height: 24),
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            return _NotificationItem(event: event, now: now);
          },
        );
      },
      );
    } 
  }
  
  class _NotificationItem extends StatelessWidget {
      final ScheduledEvent event;
      final DateTime now;
      const _NotificationItem({
        required this.event,
        required this.now,
      });
      
        @override
        Widget build(BuildContext context) {
          final difference = event.scheduledDate.difference(now);

          String timeString;
          if (difference.inHours > 0){
            timeString = "in ${difference.inHours}h ${difference.inMinutes.remainder(60)}m";
          } else {
            timeString = "in ${difference.inMinutes} minutes!";   
          }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
            color: AppColors.cardBody,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              TmdbImageHelper.buildUrl(event.posterUrl),    
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.movie_creation_rounded, color: AppColors.textMuted, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.movieTitle,
                style: const TextStyle(
                  color: AppColors.white, 
                  fontSize: 15, 
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.softPeriwinkle,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Playing $timeString on ${event.platform}",
                      style: const TextStyle(
                        color: AppColors.textSecondary, 
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
        }
  }
  
