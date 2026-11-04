import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// KaajLagbe Stitch Design System "Kinetic Trust" Frozen Typography.
/// Font Family: Plus Jakarta Sans with seamless fallback for Bengali glyphs (Noto Sans Bengali)
/// and BDT (৳) currency figures.
class AppTextStyles {
  AppTextStyles._();

  static const List<String> _bengaliFallbacks = [
    'Noto Sans Bengali',
    'Hind Siliguri',
    'sans-serif',
  ];

  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 40 / 32,
    letterSpacing: -0.64, // -0.02em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.24, // -0.01em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    letterSpacing: -0.20, // -0.01em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: 0,
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
    color: AppColors.onSurfaceVariant,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.14, // 0.01em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle labelMedium = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24, // 0.02em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 14 / 10,
    letterSpacing: 0.40, // 0.04em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);

  /// Currency display specifically styled for BDT (৳) figures
  static TextStyle currencyDisplay = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 28 / 22,
    letterSpacing: -0.22, // -0.01em
    color: AppColors.onSurface,
  ).copyWith(fontFamilyFallback: _bengaliFallbacks);
}
