import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/utils/tmdb_image_helper.dart';

class UniversalBanner extends StatelessWidget{
    final String title;
    final String subTitle;
    final String? imageUrl;
    final IconData? fallbackIcon;
    final VoidCallback onDismiss;

    const UniversalBanner({
        super.key,
        required this.title,
        required this.subTitle,
        this.imageUrl,
        this.fallbackIcon,
        required this.onDismiss,
    });

    static void show({
      required BuildContext context,
      required String title,
      required String subTitle, 
      String? imageUrl,
      IconData? fallbackIcon
    }){
      OverlayState? overlayState = Overlay.of(context);
      if(overlayState == null) return;

      late OverlayEntry overlayEntry;
      final GlobalKey<_AnimatedBannerWrapperState> key = GlobalKey<_AnimatedBannerWrapperState>();
      
      overlayEntry = OverlayEntry(
        builder:(context) => Positioned(
          bottom: 24,
          right: 24,
          child: Material(
            color: Colors.transparent,
            child: _AnimatedBannerWrapper(
              key: key,
              duration: const Duration(seconds: 5),
              onAnimationFinished: () {
                overlayEntry.remove();
              },
              child: UniversalBanner(
                title: title,
                subTitle: subTitle,
                imageUrl: imageUrl,
                fallbackIcon: fallbackIcon,
                onDismiss: () {
                  key.currentState?.dismiss();
                },
              )
            )
          )
          ),
      );

      overlayState.insert(overlayEntry);
    }
    
    @override
    Widget build(BuildContext context) {
      return Container(
      width: 380,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.plannerSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.softPeriwinkle, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), 
            blurRadius: 15, 
            offset: const Offset(0, 5)
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dynamic Leading Widget (Image or Icon)
          if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                TmdbImageHelper.buildUrl(imageUrl),
                width: 40,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _FallbackIconBox(icon: fallbackIcon ?? Icons.movie_creation_rounded),
              ),
            )
          else
            _FallbackIconBox(icon: fallbackIcon ?? Icons.notifications_active_rounded),
          
          const SizedBox(width: 16),
          
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.softPeriwinkle,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Close Button
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
            onPressed: onDismiss,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _FallbackIconBox extends StatelessWidget{
  final IconData icon;
  const _FallbackIconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.softPeriwinkle.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.softPeriwinkle, size: 20),
    );
  }
}

class _AnimatedBannerWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onAnimationFinished;

  const _AnimatedBannerWrapper({
    super.key, 
    required this.child,
    required this.duration,
    required this.onAnimationFinished,
  });

  @override
  State<_AnimatedBannerWrapper> createState() => _AnimatedBannerWrapperState();
}

class _AnimatedBannerWrapperState extends State<_AnimatedBannerWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Slide from right to left
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0.0), // Starts 120% off-screen to the right
      end: Offset.zero, // Ends at its normal position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    // 1. Play entrance animation immediately
    _controller.forward();

    // 2. Start auto-dismiss countdown
    _autoDismissTimer = Timer(widget.duration, dismiss);
  }

  // We can call this to manually trigger the slide-out
  void dismiss() {
    _autoDismissTimer?.cancel();
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) widget.onAnimationFinished();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}