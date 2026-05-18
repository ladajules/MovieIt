import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../models/scheduled_event.dart';
import '../services/local_db_service.dart';
import '../utils/tmdb_image_helper.dart';

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: LocalDbService().listenToEvents(),
      builder: (context, box, _) {
        LocalDbService().syncOverdueEventsAsWatched();
        final pendingEvents =
            box.values.where((e) => e.isWatched && !e.isReviewed).toList();
        
        if (pendingEvents.isEmpty) {
          return const SizedBox.shrink();
        }

        pendingEvents.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
        final event = pendingEvents.first;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.plannerCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.plannerSurface,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(TmdbImageHelper.buildUrl(event.posterUrl, size: 'w185')),
                    fit: BoxFit.cover,
                  ),
                ),
                child: event.posterUrl == null 
                    ? const Icon(Icons.movie_creation_outlined, color: Colors.white30, size: 22)
                    : null,
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('How was ${event.movieTitle}?', style: AppStyles.heading(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Movie night on ${DateFormat('MMMM d').format(event.scheduledDate)}', style: AppStyles.body(size: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              GestureDetector(
                onTap: () => _showReviewModal(context, event),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (i) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(Icons.star_border_rounded, color: Color(0xFF5A5A7A), size: 20),
                      )),
                      const SizedBox(width: 16),
                      Text('Add Note', style: AppStyles.body(size: 12, color: AppColors.softPeriwinkle)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewModal(BuildContext context, ScheduledEvent event) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => _ReviewModal(event: event),
    );
  }
}

class _ReviewModal extends StatefulWidget {
  final ScheduledEvent event;
  const _ReviewModal({required this.event});

  @override
  State<_ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<_ReviewModal> {
  double _rating = 0;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) return; 
    
    await LocalDbService().updateEventReview(
      widget.event.id, 
      _rating, 
      _noteController.text.trim()
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.plannerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Rate ${widget.event.movieTitle}', style: AppStyles.heading(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => _rating = index + 1.0),
                    icon: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: index < _rating ? const Color(0xFFFFD700) : const Color(0xFF5A5A7A),
                      size: 36,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            
            Text('NOTE (OPTIONAL)', style: AppStyles.label(size: 11)),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: AppStyles.body(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What did you think about the movie?',
                hintStyle: AppStyles.body(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.plannerSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.softPeriwinkle)),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _submitReview : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softPeriwinkle,
                  disabledBackgroundColor: AppColors.softPeriwinkle.withOpacity(0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Save Review', style: AppStyles.heading(size: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
