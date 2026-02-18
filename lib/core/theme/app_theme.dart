import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // New vibrant palette for children
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color secondaryIndigo = Color(0xFF818CF8);
  static const Color playfulOrange = Color(0xFFF97316);
  static const Color backgroundBlue = Color(0xFFEEF2FF);
  static const Color deepNavy = Color(0xFF1E1B4B);

  // Additional fun colors for variety
  static const Color candyPink = Color(0xFFEC4899);
  static const Color limeGreen = Color(0xFF84CC16);
  static const Color skyCyan = Color(0xFF06B6D4);
  static const Color sunnyYellow = Color(0xFFEAB308);

  // Keep legacy names for compatibility if needed, or map them
  static const Color softBlue = primaryIndigo;
  static const Color vibrantGreen = limeGreen;
  static const Color oopsColor = candyPink;
  static const Color brightOrange = playfulOrange;

  static ThemeData get light {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: primaryIndigo,
        primaryContainer: Color(0xFFE0E7FF),
        secondary: playfulOrange,
        secondaryContainer: Color(0xFFFFEDD5),
        tertiary: candyPink,
        tertiaryContainer: Color(0xFFFCE7F3),
        appBarColor: primaryIndigo,
        error: Color(0xFFEF4444),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        defaultRadius: 32.0, // More rounded
        thinBorderWidth: 2.0,
        thickBorderWidth: 4.0,
        elevatedButtonSchemeColor:
            SchemeColor.secondary, // Orange buttons by default
        elevatedButtonSecondarySchemeColor: SchemeColor.onSecondary,
        inputDecoratorRadius: 24.0,
        fabUseShape: true,
        fabSchemeColor: SchemeColor.secondary,
        cardElevation: 4.0,
        alignedDropdown: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.baloo2().fontFamily,
      textTheme: GoogleFonts.baloo2TextTheme().copyWith(
        displayLarge: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.baloo2(
          color: deepNavy,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.baloo2(
          color: deepNavy,
          fontSize: 18, // Slightly larger for kids
        ),
        bodyMedium: GoogleFonts.baloo2(color: deepNavy, fontSize: 16),
      ),
      scaffoldBackground: backgroundBlue,
    );
  }

  static ThemeData get dark {
    // Dark mode might not be primary for kids app but good to have
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: secondaryIndigo,
        primaryContainer: Color(0xFF312E81),
        secondary: playfulOrange,
        secondaryContainer: Color(0xFF7C2D12),
        tertiary: candyPink,
        tertiaryContainer: Color(0xFF831843),
        appBarColor: deepNavy,
        error: Color(0xFFEF4444),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        defaultRadius: 32.0,
        inputDecoratorRadius: 24.0,
        fabUseShape: true,
        fabSchemeColor: SchemeColor.secondary,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.baloo2().fontFamily,
    );
  }

  // Helper to get random fun color
  static Color getRandomColor(int index) {
    const colors = [
      primaryIndigo,
      playfulOrange,
      candyPink,
      limeGreen,
      skyCyan,
      sunnyYellow,
      Color(0xFF8B5CF6), // Violet
      Color(0xFFEC4899), // Pink
    ];
    return colors[index % colors.length];
  }
}
