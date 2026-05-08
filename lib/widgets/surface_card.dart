import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SurfaceCard extends StatelessWidget {
  final Widget? headerLeft;
  final Widget? headerRight;
  final Widget body;
  final EdgeInsets bodyPadding;

  const SurfaceCard({
    super.key,
    this.headerLeft,
    this.headerRight,
    required this.body,
    this.bodyPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final hasHeader = headerLeft != null || headerRight != null;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.plannerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasHeader)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.headerBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  if (headerLeft != null) headerLeft!,
                  if (headerRight != null) ...[
                    const SizedBox(width: 8),
                    headerRight!,
                  ],
                ],
              ),
            ),
          Padding(padding: bodyPadding, child: body),
        ],
      ),
    );
  }
}