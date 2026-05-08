import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'surface_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../models/scheduled_event.dart';
import '../services/local_db_service.dart';
import '../utils/stats_engine.dart';

class PlatformsCard extends StatelessWidget {
  const PlatformsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ScheduledEvent>>(
      valueListenable: LocalDbService().listenToEvents(),
      builder: (context, box, _) {
        final engine = StatsEngine(box);
        final topPlatforms = engine.getTopPlatformsWithPercentages();

        return SurfaceCard(
          headerLeft: Text('Platforms', style: AppStyles.heading(size: 14)),
          body: topPlatforms.isEmpty 
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('No platforms yet.', style: AppStyles.body()),
                )
              : topPlatforms.length == 1 && topPlatforms.first.value == 100.0
                  ? _SingleItemHero(label: topPlatforms.first.key)
                  : Column(
                      children: topPlatforms.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _PercentageBar(label: p.key, pct: p.value),
                      )).toList(),
                    ),
        );
      },
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