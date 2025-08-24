import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

// --- Configuración de Google Fonts con fallback ---
TextStyle _safeGoogleFont({
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  try {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  } catch (e) {
    // Fallback a fuente del sistema si Google Fonts falla
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontFamily: 'Roboto', // Fuente del sistema Android
    );
  }
}

// --- Estilos de Texto Tema Oscuro (Moderno) ---
TextTheme buildDarkTextTheme() {
  return TextTheme(
    displayLarge: _safeGoogleFont(
      fontSize: 52,
      fontWeight: FontWeight.bold,
      color: modernDarkText,
      letterSpacing: -1.5,
    ),
    displayMedium: _safeGoogleFont(
      fontSize: 42,
      fontWeight: FontWeight.bold,
      color: modernDarkText,
      letterSpacing: -1.0,
    ),
    displaySmall: _safeGoogleFont(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: modernDarkText,
    ),
    headlineLarge: _safeGoogleFont(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: modernDarkText,
    ),
    headlineMedium: _safeGoogleFont(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: modernDarkText,
    ),
    headlineSmall: _safeGoogleFont(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: modernDarkText,
    ),
    titleLarge: _safeGoogleFont(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: modernDarkText,
    ),
    titleMedium: _safeGoogleFont(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: modernDarkText,
    ),
    titleSmall: _safeGoogleFont(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: modernDarkText,
    ),
    bodyLarge: _safeGoogleFont(
      fontSize: 16,
      color: modernDarkText,
      height: 1.5,
    ),
    bodyMedium: _safeGoogleFont(
      fontSize: 14,
      color: modernDarkSecondaryText,
      height: 1.5,
    ),
    bodySmall: _safeGoogleFont(
      fontSize: 12,
      color: modernDarkSecondaryText,
      height: 1.4,
    ),
    labelLarge: _safeGoogleFont(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    ), // Para botones
    labelMedium: _safeGoogleFont(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: modernDarkText,
    ),
    labelSmall: _safeGoogleFont(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: modernDarkSecondaryText,
      letterSpacing: 0.5,
    ),
  ).apply(bodyColor: modernDarkText, displayColor: modernDarkText);
}

// --- Estilos de Texto Tema Claro (Moderno) ---
TextTheme buildLightTextTheme() {
  return TextTheme(
    displayLarge: _safeGoogleFont(
      fontSize: 52,
      fontWeight: FontWeight.bold,
      color: modernLightText,
      letterSpacing: -1.5,
    ),
    displayMedium: _safeGoogleFont(
      fontSize: 42,
      fontWeight: FontWeight.bold,
      color: modernLightText,
      letterSpacing: -1.0,
    ),
    displaySmall: _safeGoogleFont(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: modernLightText,
    ),
    headlineLarge: _safeGoogleFont(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: modernLightText,
    ),
    headlineMedium: _safeGoogleFont(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: modernLightText,
    ),
    headlineSmall: _safeGoogleFont(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: modernLightText,
    ),
    titleLarge: _safeGoogleFont(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: modernLightText,
    ),
    titleMedium: _safeGoogleFont(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: modernLightText,
    ),
    titleSmall: _safeGoogleFont(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: modernLightText,
    ),
    bodyLarge: _safeGoogleFont(
      fontSize: 16,
      color: modernLightText,
      height: 1.5,
    ),
    bodyMedium: _safeGoogleFont(
      fontSize: 14,
      color: modernLightSecondaryText,
      height: 1.5,
    ),
    bodySmall: _safeGoogleFont(
      fontSize: 12,
      color: modernLightSecondaryText,
      height: 1.4,
    ),
    labelLarge: _safeGoogleFont(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    ), // Para botones
    labelMedium: _safeGoogleFont(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: modernLightText,
    ),
    labelSmall: _safeGoogleFont(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: modernLightSecondaryText,
      letterSpacing: 0.5,
    ),
  ).apply(bodyColor: modernLightText, displayColor: modernLightText);
}

// Helper para el logo (puedes personalizarlo más)
Widget buildModernLogo(bool isDarkMode, {double size = 24}) {
  return Text(
    "PRYTEMAS",
    style: GoogleFonts.orbitron(
      // Una fuente futurista para el logo
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? modernDarkPrimary : modernLightPrimary,
      letterSpacing: 1.5,
    ),
  );
}
