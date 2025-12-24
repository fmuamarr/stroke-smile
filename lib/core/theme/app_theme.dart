import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color successColor;
  final Color warningColor;
  final double defaultRadius;
  final double cardPadding;

  const AppThemeExtension({
    required this.successColor,
    required this.warningColor,
    required this.defaultRadius,
    required this.cardPadding,
  });

  @override
  AppThemeExtension copyWith({
    Color? successColor,
    Color? warningColor,
    double? defaultRadius,
    double? cardPadding,
  }) {
    return AppThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      cardPadding: cardPadding ?? this.cardPadding,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      defaultRadius: lerpDouble(defaultRadius, other.defaultRadius, t)!,
      cardPadding: lerpDouble(cardPadding, other.cardPadding, t)!,
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.blueSoft,
      onPrimary: AppColors.white,
      secondary: AppColors.greenHealth,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.grayText,
      tertiary: AppColors.blueLight,
      onTertiary: AppColors.grayText,
    ),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.grayText,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.grayText,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.grayText,
      ),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, color: AppColors.grayText),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, color: AppColors.grayText),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeExtension(
        successColor: AppColors.greenHealth,
        warningColor: AppColors.warning,
        defaultRadius: 12.0,
        cardPadding: 16.0,
      ),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueSoft,
        foregroundColor: AppColors.white,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
    ),
  );
}
