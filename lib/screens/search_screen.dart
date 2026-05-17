import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movieit/providers/movie_provider.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/theme/app_styles.dart';
import 'package:movieit/widgets/layout/custom_footer.dart';
import 'package:movieit/widgets/movieit_search_bar.dart';
import 'package:movieit/widgets/search_result_list.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Map<int, String> _genreLabels = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  static const Map<String, String> _languageLabels = {
    'en': 'English',
    'af': 'Afrikaans',
    'ar': 'Arabic',
    'bg': 'Bulgarian',
    'bn': 'Bengali',
    'ca': 'Catalan',
    'cs': 'Czech',
    'cy': 'Welsh',
    'da': 'Danish',
    'de': 'German',
    'el': 'Greek',
    'eo': 'Esperanto',
    'es': 'Spanish',
    'et': 'Estonian',
    'eu': 'Basque',
    'fa': 'Persian',
    'fi': 'Finnish',
    'fr': 'French',
    'ga': 'Irish',
    'gl': 'Galician',
    'gu': 'Gujarati',
    'he': 'Hebrew',
    'hi': 'Hindi',
    'hr': 'Croatian',
    'hu': 'Hungarian',
    'id': 'Indonesian',
    'it': 'Italian',
    'ja': 'Japanese',
    'ka': 'Georgian',
    'kn': 'Kannada',
    'ko': 'Korean',
    'lt': 'Lithuanian',
    'lv': 'Latvian',
    'mk': 'Macedonian',
    'ml': 'Malayalam',
    'mr': 'Marathi',
    'ms': 'Malay',
    'mt': 'Maltese',
    'nb': 'Norwegian',
    'nl': 'Dutch',
    'pa': 'Punjabi',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'sq': 'Albanian',
    'sr': 'Serbian',
    'sv': 'Swedish',
    'sw': 'Swahili',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tl': 'Filipino',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'vi': 'Vietnamese',
    'zh': 'Chinese (Mandarin)',
    'zu': 'Zulu',
  };

  static const RangeValues _defaultRuntimeRange = RangeValues(60, 240);
  static const double _defaultMinRating = 1.0;

  String _query = '';
  Set<int> _selectedGenreIds = <int>{};
  RangeValues _runtimeRange = _defaultRuntimeRange;
  double _minRating = _defaultMinRating;
  Set<String> _selectedLanguages = <String>{};
  bool _matchAllGenres = false;
  bool _isFilterActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .loadTrendingAndDiscoverAndTop4();
    });
  }

  bool _filtersAreDefault({
    required Set<int> genres,
    required RangeValues runtimeRange,
    required double minRating,
    required Set<String> languages,
    required bool matchAllGenres,
  }) {
    return genres.isEmpty &&
        runtimeRange == _defaultRuntimeRange &&
        minRating == _defaultMinRating &&
        languages.isEmpty &&
        !matchAllGenres;
  }

  int _estimateMatchCount({
    required int baseCount,
    required Set<int> genres,
    required bool matchAllGenres,
    required RangeValues runtimeRange,
    required double minRating,
    required Set<String> languages,
  }) {
    double factor = 1.0;
    final runtimeSpan = (runtimeRange.end - runtimeRange.start) /
        (_defaultRuntimeRange.end - _defaultRuntimeRange.start);

    if (genres.isNotEmpty) {
      factor *= matchAllGenres
          ? math.max(0.16, 1 - (genres.length * 0.2))
          : math.max(0.28, 1 - (genres.length * 0.11));
    }

    if (languages.isNotEmpty) {
      factor *= math.max(0.24, 1 - (languages.length * 0.13));
    }

    factor *= math.max(0.18, 0.35 + (runtimeSpan * 0.65));
    factor *= math.max(0.18, 1 - (((minRating - 1) / 9) * 0.52));

    return math.max(1, math.min(baseCount, (baseCount * factor).round()));
  }

  Future<void> _applyFilters({
    required Set<int> genres,
    required RangeValues runtimeRange,
    required double minRating,
    required Set<String> languages,
    required bool matchAllGenres,
  }) async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final isDefault = _filtersAreDefault(
      genres: genres,
      runtimeRange: runtimeRange,
      minRating: minRating,
      languages: languages,
      matchAllGenres: matchAllGenres,
    );

    setState(() {
      _selectedGenreIds = Set<int>.from(genres);
      _runtimeRange = runtimeRange;
      _minRating = minRating;
      _selectedLanguages = Set<String>.from(languages);
      _matchAllGenres = matchAllGenres;
      _isFilterActive = !isDefault;
      _query = '';
    });

    if (isDefault) {
      await movieProvider.loadTrendingAndDiscoverAndTop4();
      return;
    }

    await movieProvider.loadFilteredMovies(
      genres: genres.toList(),
      matchAll: matchAllGenres,
      minRuntime: runtimeRange.start,
      maxRuntime: runtimeRange.end,
      minRating: minRating,
      languages: languages.toList(),
    );
  }

  void _onSearch(String query) {
    setState(() {
      _query = query;
      _selectedGenreIds = <int>{};
      _selectedLanguages = <String>{};
      _runtimeRange = _defaultRuntimeRange;
      _minRating = _defaultMinRating;
      _matchAllGenres = false;
      _isFilterActive = false;
    });

    if (query.isNotEmpty) {
      Provider.of<MovieProvider>(context, listen: false).loadSearch(query);
    }
  }

  void _onFiltersTap() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    Set<int> selectedGenreIds = Set<int>.from(_selectedGenreIds);
    RangeValues runtimeRange = _runtimeRange;
    double minRating = _minRating;
    Set<String> selectedLanguages = Set<String>.from(_selectedLanguages);
    bool matchAllGenres = _matchAllGenres;
    bool genresExpanded = false;
    bool languagesExpanded = false;

    final baseCount = movieProvider.searchMoviesList.isNotEmpty
        ? movieProvider.searchMoviesList.length
        : movieProvider.discoverMoviesList.isNotEmpty
            ? movieProvider.discoverMoviesList.length
            : 622;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.76),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final estimatedMatchCount = _estimateMatchCount(
              baseCount: baseCount,
              genres: selectedGenreIds,
              matchAllGenres: matchAllGenres,
              runtimeRange: runtimeRange,
              minRating: minRating,
              languages: selectedLanguages,
            );

            final visibleGenres = genresExpanded
                ? _genreLabels.entries.toList()
                : _genreLabels.entries.take(7).toList();
            final hiddenGenreCount =
                math.max(0, _genreLabels.length - visibleGenres.length);

            final visibleLanguages = languagesExpanded
                ? _languageLabels.entries.toList()
                : _languageLabels.entries.take(7).toList();
            final hiddenLanguageCount =
                math.max(0, _languageLabels.length - visibleLanguages.length);

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 860, maxHeight: 760),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.plannerBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.42),
                        blurRadius: 34,
                        offset: const Offset(0, 22),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 22, 20, 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Refine your picks',
                                    style: AppStyles.heading(size: 28),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        '$estimatedMatchCount movies match',
                                        style: AppStyles.body(
                                          size: 14,
                                          color: AppColors.softPeriwinkle,
                                        ),
                                      ),
                                      Text(
                                        '\u00B7',
                                        style: AppStyles.body(
                                          size: 14,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setModalState(() {
                                            selectedGenreIds = <int>{};
                                            runtimeRange = _defaultRuntimeRange;
                                            minRating = _defaultMinRating;
                                            selectedLanguages = <String>{};
                                            matchAllGenres = false;
                                            genresExpanded = false;
                                            languagesExpanded = false;
                                          });
                                        },
                                        child: Text(
                                          '\u21BB Reset all',
                                          style: AppStyles.body(
                                            size: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textMuted,
                              ),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.cardBorder.withValues(alpha: 0.9),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildModalSectionHeader(
                                label: selectedGenreIds.isEmpty
                                    ? 'GENRES'
                                    : 'GENRES \u00B7 ${selectedGenreIds.length}',
                                trailing: selectedGenreIds.length >= 2
                                    ? _buildMatchLogicToggle(
                                        matchAllGenres: matchAllGenres,
                                        onChanged: (value) {
                                          setModalState(() {
                                            matchAllGenres = value;
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  ...visibleGenres.map((entry) {
                                    final isSelected =
                                        selectedGenreIds.contains(entry.key);
                                    return _buildFilterChip(
                                      label: entry.value,
                                      isSelected: isSelected,
                                      onTap: () {
                                        setModalState(() {
                                          if (isSelected) {
                                            selectedGenreIds.remove(entry.key);
                                            if (selectedGenreIds.length < 2) {
                                              matchAllGenres = false;
                                            }
                                          } else {
                                            selectedGenreIds.add(entry.key);
                                          }
                                        });
                                      },
                                    );
                                  }),
                                  if (!genresExpanded && hiddenGenreCount > 0)
                                    TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          genresExpanded = true;
                                        });
                                      },
                                      child: Text(
                                        '+ $hiddenGenreCount more',
                                        style: AppStyles.body(
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              _buildModalSectionHeader(
                                label: 'RUNTIME',
                                trailing: Text(
                                  '${runtimeRange.start.round()} - ${runtimeRange.end.round()} min',
                                  style: AppStyles.heading(size: 14),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildRuntimeHistogram(runtimeRange),
                              const SizedBox(height: 10),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  activeTrackColor: AppColors.softPeriwinkle,
                                  inactiveTrackColor:
                                      AppColors.accentSoft.withValues(
                                    alpha: 0.75,
                                  ),
                                  rangeTrackShape:
                                      const RoundedRectRangeSliderTrackShape(),
                                  rangeThumbShape:
                                      const RoundRangeSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayColor:
                                      AppColors.softPeriwinkle.withValues(
                                    alpha: 0.12,
                                  ),
                                  thumbColor: AppColors.white,
                                  overlappingShapeStrokeColor:
                                      AppColors.softPeriwinkle,
                                ),
                                child: RangeSlider(
                                  values: runtimeRange,
                                  min: _defaultRuntimeRange.start,
                                  max: _defaultRuntimeRange.end,
                                  divisions: 18,
                                  labels: RangeLabels(
                                    '${runtimeRange.start.round()} min',
                                    '${runtimeRange.end.round()} min',
                                  ),
                                  onChanged: (value) {
                                    setModalState(() {
                                      runtimeRange = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  _AxisLabel('1H'),
                                  _AxisLabel('2H'),
                                  _AxisLabel('3H'),
                                  _AxisLabel('4H'),
                                ],
                              ),
                              const SizedBox(height: 28),
                              _buildModalSectionHeader(
                                label: 'MINIMUM RATING',
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: AppColors.softPeriwinkle,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${minRating.toStringAsFixed(1)}+',
                                      style: AppStyles.heading(size: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 5,
                                  activeTrackColor: AppColors.softPeriwinkle,
                                  inactiveTrackColor:
                                      AppColors.accentSoft.withValues(
                                    alpha: 0.75,
                                  ),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayColor:
                                      AppColors.softPeriwinkle.withValues(
                                    alpha: 0.12,
                                  ),
                                  thumbColor: AppColors.white,
                                ),
                                child: Slider(
                                  value: minRating,
                                  min: 1.0,
                                  max: 10.0,
                                  divisions: 18,
                                  onChanged: (value) {
                                    setModalState(() {
                                      minRating = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 28),
                              _buildModalSectionHeader(
                                label: selectedLanguages.isEmpty
                                    ? 'LANGUAGES'
                                    : 'LANGUAGES \u00B7 ${selectedLanguages.length}',
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  ...visibleLanguages.map((entry) {
                                    final isSelected =
                                        selectedLanguages.contains(entry.key);
                                    return _buildFilterChip(
                                      label: entry.value,
                                      isSelected: isSelected,
                                      onTap: () {
                                        setModalState(() {
                                          if (isSelected) {
                                            selectedLanguages.remove(entry.key);
                                          } else {
                                            selectedLanguages.add(entry.key);
                                          }
                                        });
                                      },
                                    );
                                  }),
                                  if (!languagesExpanded &&
                                      hiddenLanguageCount > 0)
                                    TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          languagesExpanded = true;
                                        });
                                      },
                                      child: Text(
                                        '+ $hiddenLanguageCount more',
                                        style: AppStyles.body(
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.cardBorder.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.softPeriwinkle,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              await _applyFilters(
                                genres: selectedGenreIds,
                                runtimeRange: runtimeRange,
                                minRating: minRating,
                                languages: selectedLanguages,
                                matchAllGenres: matchAllGenres,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Show $estimatedMatchCount movies',
                              style: AppStyles.heading(size: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalSectionHeader({
    required String label,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.label(size: 15, color: AppColors.textSecondary),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildMatchLogicToggle({
    required bool matchAllGenres,
    required ValueChanged<bool> onChanged,
  }) {
    Widget segment({
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.softPeriwinkle
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                label,
                style: AppStyles.body(
                  size: 12,
                  color: selected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 172,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.plannerSurface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          segment(
            label: 'Match Any',
            selected: !matchAllGenres,
            onTap: () => onChanged(false),
          ),
          segment(
            label: 'Match All',
            selected: matchAllGenres,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.softPeriwinkle,
      backgroundColor: AppColors.plannerSurface,
      side: BorderSide(
        color: isSelected ? AppColors.softPeriwinkle : AppColors.cardBorder,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      labelStyle: AppStyles.body(
        size: 14,
        color: isSelected ? AppColors.white : AppColors.textSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }

  Widget _buildRuntimeHistogram(RangeValues range) {
    const barHeights = <double>[
      2,
      4,
      7,
      10,
      14,
      19,
      24,
      30,
      26,
      19,
      13,
      9,
      6,
      4,
    ];

    final min = _defaultRuntimeRange.start;
    final max = _defaultRuntimeRange.end;
    final span = max - min;

    return SizedBox(
      height: 34,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barHeights.length, (index) {
          final barStart = min + ((span / barHeights.length) * index);
          final barEnd = min + ((span / barHeights.length) * (index + 1));
          final isActive = barEnd >= range.start && barStart <= range.end;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: barHeights[index],
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.softPeriwinkle.withValues(alpha: 0.75)
                      : AppColors.accentSoft.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterOptions() {
    final activeCount = _selectedGenreIds.length +
        _selectedLanguages.length +
        (_runtimeRange != _defaultRuntimeRange ? 1 : 0) +
        (_minRating != _defaultMinRating ? 1 : 0);

    return Row(
      children: [
        InkWell(
          onTap: _onFiltersTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _isFilterActive
                  ? AppColors.softPeriwinkle.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    _isFilterActive ? AppColors.softPeriwinkle : Colors.white24,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune_rounded,
                  color:
                      _isFilterActive ? AppColors.softPeriwinkle : Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _isFilterActive && activeCount > 0
                      ? 'Filters \u00B7 $activeCount'
                      : 'Filters',
                  style: AppStyles.body(
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(height: 16),
                  MovieItSearchBar(onChanged: _onSearch),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildFilterOptions(),
                  ),
                  const SizedBox(height: 16),
                  Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                      if (movieProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
              
                      if (movieProvider.errorMessage.isNotEmpty) {
                        return Center(
                          child: Text(
                            movieProvider.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
              
                      final movieListToDisplay = (_query.isEmpty && !_isFilterActive)
                          ? movieProvider.discoverMoviesList
                          : movieProvider.searchMoviesList;
              
                      if (movieListToDisplay.isEmpty &&
                          (_query.isNotEmpty || _isFilterActive)) {
                        return Center(
                          child: Column(
                            children: [
                              Lottie.asset(
                                'assets/animations/Search.json',
                                width: 250,
                                height: 250,
                              ),
                              const Text(
                                'No movies found.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
              
                      return SearchResultGrid(movies: movieListToDisplay);
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
                const CustomFooter(),
              ],
          ),
        ),
      ),
    ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;

  const _AxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppStyles.body(size: 12, color: AppColors.textMuted),
    );
  }
}
