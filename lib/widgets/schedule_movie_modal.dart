import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movieit/models/scheduled_event.dart';
import 'package:movieit/models/watchlist_item.dart';
import 'package:movieit/services/local_db_service.dart';
import 'package:movieit/utils/tmdb_image_helper.dart';
import '../services/api_client.dart';
import '../models/movie_details_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class ScheduleMovieModal extends StatefulWidget {
  final MovieDetails movie;

  const ScheduleMovieModal({super.key, required this.movie});

  @override
  State<ScheduleMovieModal> createState() => _ScheduleMovieModalState();
}

class _ScheduleMovieModalState extends State<ScheduleMovieModal> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPlatform;
  List<String> _platforms = []; 
  bool _isLoadingPlatforms = true;

  int _selectedReminder = 10;

  @override
  void initState() {
    super.initState();
    _fetchPlatforms();
  }

  Future<void> _fetchPlatforms() async {
    try {
      final sources = await ApiClient().getSources(widget.movie.id.toString());
      
      setState(() {
        _platforms = sources.map((s) => s.name).toSet().cast<String>().toList();
        
        _platforms.add('Local File');
        _platforms.add('Pirated HEHE');
        _platforms.add('In Theater');
        _isLoadingPlatforms = false;
      });
    } catch (e) {
      setState(() {
        _platforms = ['Local File'];
        _platforms.add('Pirated HEHE');
        _platforms.add('In Theater');
        _isLoadingPlatforms = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.softPeriwinkle),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.softPeriwinkle),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isTonight = _selectedDate?.day == now.day;
    final isTomorrow = _selectedDate?.day == now.add(const Duration(days: 1)).day;
    final is8PM = _selectedTime?.hour == 20 && _selectedTime?.minute == 0;
    final is10PM = _selectedTime?.hour == 22 && _selectedTime?.minute == 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 750,
          height: 480,
          color: AppColors.plannerBg,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.movie.posterUrl ?? widget.movie.backdropUrl ?? 'https://via.placeholder.com/400x600',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 32,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SCHEDULING',
                            style: GoogleFonts.inter(
                              color: AppColors.softPeriwinkle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.movie.title.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Plan your night', style: AppStyles.heading(size: 20)),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                            hoverColor: Colors.white10,
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text('DATE', style: AppStyles.label(size: 11)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _QuickPill(
                                      label: 'Tonight',
                                      isActive: isTonight,
                                      onTap: () => setState(() => _selectedDate = now),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: 'Tomorrow',
                                      isActive: isTomorrow,
                                      onTap: () => setState(() => _selectedDate = now.add(const Duration(days: 1))),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: (!isTonight && !isTomorrow && _selectedDate != null)
                                          ? DateFormat('MMM d').format(_selectedDate!)
                                          : 'Pick Date',
                                      icon: Icons.calendar_today_rounded,
                                      isActive: (!isTonight && !isTomorrow && _selectedDate != null),
                                      onTap: _pickDate,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                Text('TIME', style: AppStyles.label(size: 11)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _QuickPill(
                                      label: '8:00 PM',
                                      isActive: is8PM,
                                      onTap: () => setState(() => _selectedTime = const TimeOfDay(hour: 20, minute: 0)),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: '10:00 PM',
                                      isActive: is10PM,
                                      onTap: () => setState(() => _selectedTime = const TimeOfDay(hour: 22, minute: 0)),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: (!is8PM && !is10PM && _selectedTime != null)
                                          ? _selectedTime!.format(context)
                                          : 'Pick Time',
                                      icon: Icons.access_time_rounded,
                                      isActive: (!is8PM && !is10PM && _selectedTime != null),
                                      onTap: _pickTime,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                Text('REMINDER', style: AppStyles.label(size: 11)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _QuickPill(
                                      label: '5 mins',
                                      isActive: _selectedReminder == 5,
                                      onTap: () => setState(() => _selectedReminder = 5),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: '10 mins',
                                      isActive: _selectedReminder == 10,
                                      onTap: () => setState(() => _selectedReminder = 10),
                                    ),
                                    const SizedBox(width: 10),
                                    _QuickPill(
                                      label: '30 mins',
                                      isActive: _selectedReminder == 30,
                                      onTap: () => setState(() => _selectedReminder = 30),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                Text('WHERE TO WATCH', style: AppStyles.label(size: 11)),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  dropdownColor: AppColors.plannerCard,
                                  value: _selectedPlatform,
                                  hint: Text(_isLoadingPlatforms ? 'Loading...' : 'Select a platform', style: AppStyles.body(size: 14)),
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.plannerSurface,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.cardBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.cardBorder),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.softPeriwinkle),
                                    ),
                                  ),
                                  items: _platforms.map((String platform) {
                                    return DropdownMenuItem(
                                      value: platform,
                                      child: Text(platform, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() => _selectedPlatform = val),
                                ),
                             ]
                          )
                        )
                      ),

                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_selectedDate != null && _selectedTime != null && _selectedPlatform != null)
                              ? () async {
                                final db = LocalDbService();

                                final scheduledDateTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute,
                                );

                                if (!db.isInWatchlist(widget.movie.id)) {
                                  final watchlistItem = WatchlistItem(
                                    tmdbId: widget.movie.id,
                                    title: widget.movie.title,
                                    posterPath: widget.movie.posterUrl ?? '',
                                    runtimeMinutes: widget.movie.runtime,
                                    genreIds: [], // TODO: pass the IDs 
                                    cachedAt: DateTime.now().toUtc(),
                                  );

                                  await db.toggleWatchlist(watchlistItem);
                                }

                                final event = ScheduledEvent(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(), 
                                  movieId: widget.movie.id.toString(), 
                                  movieTitle: widget.movie.title, 
                                  posterUrl: TmdbImageHelper.buildUrl(widget.movie.posterUrl), 
                                  scheduledDate: scheduledDateTime, 
                                  platform: _selectedPlatform!, 
                                  runtime: widget.movie.runtime, 
                                  genres: widget.movie.genres,
                                  reminderOffsetMinutes: _selectedReminder,
                                  isNotified: false,
                                );

                                await db.scheduleEvent(event);

                                Navigator.of(context).pop();
                              }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.softPeriwinkle,
                            disabledBackgroundColor: AppColors.softPeriwinkle.withOpacity(0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Lock in Movie Night',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;

  const _QuickPill({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.softPeriwinkle : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? AppColors.softPeriwinkle : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: isActive ? Colors.white : Colors.white54),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}