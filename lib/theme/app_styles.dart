import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static TextStyle label({double size = 11, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textMuted,
        letterSpacing: 1.1,
      );

  static TextStyle value({double size = 22, Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.white,
      );

  static TextStyle body({double size = 13, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        color: color ?? AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle heading({double size = 16, Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.white,
      );
}
