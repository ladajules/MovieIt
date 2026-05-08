import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_styles.dart';

import '../widgets/calendar_card.dart';
import '../widgets/monthly_goal_card.dart';
import '../widgets/pending_review_card.dart';
import '../widgets/platforms_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/roulette_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/watchlist_section.dart';

import '../services/local_db_service.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.plannerBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const _TopBar(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 900) {
                      return const _DesktopLayout();
                    }
                    return const _MobileLayout();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const ScheduleFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 12),
      child: Row(
        children: [
          Text('My Planner', style: AppStyles.value(size: 26)),

          // TO REMVOE SOOONESTTT
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.redAccent),
            onPressed: () async {
              await LocalDbService().injectTestData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test Data Injected!')),
                );
              }
            },
          ),
          // ======================================================================

          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.plannerSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.import_export_rounded, color: AppColors.textSecondary, size: 18),
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                StreakCard(),
                SizedBox(height: 12),
                MonthlyGoalCard(),
                SizedBox(height: 12),
                CalendarCard(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            flex: 5,
            child: Column(
              children: [
                StatsCard(),
                SizedBox(height: 16),
                PendingReviewCard(),
                SizedBox(height: 16),
                WatchlistSection(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                RouletteCard(),
                SizedBox(height: 12),
                PlatformsCard(),
                SizedBox(height: 12),
                RecentActivityCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
      child: Column(
        children: const [
          Row(children: [
            Expanded(child: StreakCard()),
            SizedBox(width: 12),
            Expanded(child: MonthlyGoalCard()),
          ]),
          SizedBox(height: 12),
          StatsCard(),
          SizedBox(height: 12),
          CalendarCard(),
          SizedBox(height: 12),
          PendingReviewCard(),
          SizedBox(height: 12),
          RouletteCard(),
          SizedBox(height: 12),
          WatchlistSection(),
          SizedBox(height: 12),
          PlatformsCard(),
          SizedBox(height: 12),
          RecentActivityCard(),
        ],
      ),
    );
  }
}

class ScheduleFab extends StatelessWidget {
  const ScheduleFab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.plannerCard,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.softPeriwinkle.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(color: AppColors.softPeriwinkle.withOpacity(0.15), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppColors.softPeriwinkle, size: 18),
            const SizedBox(width: 8),
            Text('Schedule a movie night', style: AppStyles.body(size: 13, color: AppColors.softPeriwinkle)),
          ],
        ),
      ),
    );
  }
}

