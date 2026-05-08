import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'surface_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../models/scheduled_event.dart';
import '../utils/stats_engine.dart';
import '../models/user_stats.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserStats>>(
      valueListenable: Hive.box<UserStats>('user_stats').listenable(),
      builder: (context, statsBox, _) {
        final stats = statsBox.get('user_stats') ?? UserStats();

        final eventsBox = Hive.box<ScheduledEvent>('scheduled_event');
        final engine = StatsEngine(eventsBox, stats);
        
        final nightsPlanned = engine.getTotalNightsPlanned();
        final totalMins = engine.getTotalRuntimeMinutes();
        final avgRating = engine.getAverageRating();
        final pending = engine.getPendingReviewCount();
        final topGenres = engine.getTopGenresWithPercentages();

        final hours = totalMins ~/ 60;
        final mins = totalMins % 60;
        final runtimeStr = hours > 0 ? '${hours}h ${mins > 0 ? '${mins}m' : ''}' : '${mins}m';

        return SurfaceCard(
          headerLeft: Text('Your stats', style: AppStyles.heading(size: 18)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: _MetricBox(value: '$nightsPlanned', label: 'PLANNED')),
                const SizedBox(width: 10),
                Expanded(child: _MetricBox(value: runtimeStr, label: 'RUNTIME')),
                const SizedBox(width: 10),
                Expanded(child: _MetricBox(value: avgRating.toStringAsFixed(1), label: 'AVG RATING')),
                const SizedBox(width: 10),
                Expanded(child: _MetricBox(value: '$pending', label: 'PENDING')),
              ]),
              const SizedBox(height: 20),
              
              Text('TOP GENRES', style: AppStyles.label()),
              const SizedBox(height: 12),
              
              if (topGenres.isEmpty)
                Text('No movies scheduled yet.', style: AppStyles.body())
              else if (topGenres.length == 1 && topGenres.first.value == 100.0)
                _SingleItemHero(label: topGenres.first.key)
              else
                ...topGenres.map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PercentageBar(label: g.key, pct: g.value),
                )),
            ],
          ),
        );
      },
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String value;
  final String label;
  const _MetricBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.plannerSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(value, style: AppStyles.value(size: 22), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(label, style: AppStyles.label(size: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SingleItemHero extends StatelessWidget {
  final String label;
  const _SingleItemHero({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.plannerSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text('100%', style: AppStyles.value(size: 42, color: AppColors.softPeriwinkle)),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: AppStyles.heading(size: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PercentageBar extends StatelessWidget {
  final String label;
  final double pct;
  const _PercentageBar({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyles.body(size: 13, color: AppColors.white)),
            Text('${pct.toInt()}%', style: AppStyles.body(size: 12)),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(builder: (ctx, c) => Stack(children: [
          Container(height: 7, decoration: BoxDecoration(color: AppColors.dividerSubtle, borderRadius: BorderRadius.circular(4))),
          Container(
            height: 7, 
            width: c.maxWidth * (pct / 100), 
            decoration: BoxDecoration(color: AppColors.softPeriwinkle, borderRadius: BorderRadius.circular(4))
          ),
        ])),
      ],
    );
  }
}