import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

@immutable
class MovieItThemeColors extends ThemeExtension<MovieItThemeColors> {
  final Color pageBackground;
  final Color pageBackgroundAlt;
  final Color glassSurface;
  final Color glassBorder;
  final Color cardSurface;
  final Color cardBorder;
  final Color headerSurface;
  final Color accent;
  final Color accentSoft;
  final Color accentDim;
  final Color success;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color shadowColor;
  final Gradient heroGradient;

  const MovieItThemeColors({
    required this.pageBackground,
    required this.pageBackgroundAlt,
    required this.glassSurface,
    required this.glassBorder,
    required this.cardSurface,
    required this.cardBorder,
    required this.headerSurface,
    required this.accent,
    required this.accentSoft,
    required this.accentDim,
    required this.success,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.shadowColor,
    required this.heroGradient,
  });

  static const dark = MovieItThemeColors(
    pageBackground: AppColors.plannerBg,
    pageBackgroundAlt: AppColors.black,
    glassSurface: Color(0x14FFFFFF),
    glassBorder: Color(0x2EFFFFFF),
    cardSurface: AppColors.plannerCard,
    cardBorder: AppColors.cardBorder,
    headerSurface: AppColors.headerBg,
    accent: AppColors.softPeriwinkle,
    accentSoft: AppColors.accentSoft,
    accentDim: AppColors.accentDim,
    success: AppColors.successGreen,
    textPrimary: AppColors.white,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    shadowColor: Color(0x80000000),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
    ),
  );

  static const light = MovieItThemeColors(
    pageBackground: Color(0xFFF7F5FF),
    pageBackgroundAlt: Color(0xFFFFFFFF),
    glassSurface: Color(0xBFFFFFFF),
    glassBorder: Color(0x99FFFFFF),
    cardSurface: Color(0xFFFDFBFF),
    cardBorder: Color(0xFFDCCFF6),
    headerSurface: Color(0xFFF2ECFF),
    accent: AppColors.softPeriwinkle,
    accentSoft: Color(0xFFEFE6FF),
    accentDim: Color(0xFF8E5EEB),
    success: AppColors.successGreen,
    textPrimary: Color(0xFF18142A),
    textSecondary: Color(0xFF4C4568),
    textMuted: Color(0xFF7B7398),
    shadowColor: Color(0x1F6E49B8),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF9F5FF), Color(0xFFFFFFFF), Color(0xFFEAF1FF)],
    ),
  );

  @override
  ThemeExtension<MovieItThemeColors> copyWith({
    Color? pageBackground,
    Color? pageBackgroundAlt,
    Color? glassSurface,
    Color? glassBorder,
    Color? cardSurface,
    Color? cardBorder,
    Color? headerSurface,
    Color? accent,
    Color? accentSoft,
    Color? accentDim,
    Color? success,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? shadowColor,
    Gradient? heroGradient,
  }) {
    return MovieItThemeColors(
      pageBackground: pageBackground ?? this.pageBackground,
      pageBackgroundAlt: pageBackgroundAlt ?? this.pageBackgroundAlt,
      glassSurface: glassSurface ?? this.glassSurface,
      glassBorder: glassBorder ?? this.glassBorder,
      cardSurface: cardSurface ?? this.cardSurface,
      cardBorder: cardBorder ?? this.cardBorder,
      headerSurface: headerSurface ?? this.headerSurface,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentDim: accentDim ?? this.accentDim,
      success: success ?? this.success,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      shadowColor: shadowColor ?? this.shadowColor,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  ThemeExtension<MovieItThemeColors> lerp(
    covariant ThemeExtension<MovieItThemeColors>? other,
    double t,
  ) {
    if (other is! MovieItThemeColors) return this;

    return MovieItThemeColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      pageBackgroundAlt:
          Color.lerp(pageBackgroundAlt, other.pageBackgroundAlt, t)!,
      glassSurface: Color.lerp(glassSurface, other.glassSurface, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      headerSurface: Color.lerp(headerSurface, other.headerSurface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      success: Color.lerp(success, other.success, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
    );
  }
}

class MovieItTheme {
  MovieItTheme._();

  static ThemeData dark() {
    const tokens = MovieItThemeColors.dark;
    const scheme = ColorScheme.dark(
      primary: AppColors.softPeriwinkle,
      secondary: AppColors.wisteria,
      surface: AppColors.plannerCard,
      onSurface: AppColors.white,
      error: Colors.redAccent,
    );

    return _buildTheme(
      brightness: Brightness.dark,
      scheme: scheme,
      tokens: tokens,
    );
  }

  static ThemeData light() {
    const tokens = MovieItThemeColors.light;
    const scheme = ColorScheme.light(
      primary: AppColors.softPeriwinkle,
      secondary: AppColors.wisteria,
      surface: Color(0xFFFDFBFF),
      onSurface: Color(0xFF18142A),
      error: Colors.redAccent,
    );

    return _buildTheme(
      brightness: Brightness.light,
      scheme: scheme,
      tokens: tokens,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme scheme,
    required MovieItThemeColors tokens,
  }) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final displayFont = GoogleFonts.poppinsTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.pageBackgroundAlt,
      canvasColor: tokens.pageBackground,
      shadowColor: tokens.shadowColor,
      dividerColor: tokens.cardBorder,
      splashFactory: InkRipple.splashFactory,
      textTheme: displayFont.apply(
        bodyColor: tokens.textPrimary,
        displayColor: tokens.textPrimary,
      ),
      extensions: <ThemeExtension<dynamic>>[
        brightness == Brightness.dark
            ? MovieItThemeColors.dark
            : MovieItThemeColors.light,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.cardSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: tokens.cardBorder),
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.cardSurface,
        elevation: 0,
        shadowColor: tokens.shadowColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: tokens.cardBorder),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.softPeriwinkle;
          }
          return tokens.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.softPeriwinkle.withValues(alpha: 0.35);
          }
          return tokens.accentSoft;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softPeriwinkle,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.glassSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: tokens.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.softPeriwinkle),
        ),
      ),
    );
  }
}

extension MovieItThemeContext on BuildContext {
  MovieItThemeColors get movieItTheme =>
      Theme.of(this).extension<MovieItThemeColors>()!;
}
