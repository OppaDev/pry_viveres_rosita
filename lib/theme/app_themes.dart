import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'text_styles.dart';
import 'button_styles.dart';
import 'input_styles.dart';
import 'layout_styles.dart';

// Define una clase para las extensiones de tema si quieres pasar degradados.
// Opcional, puedes acceder a ellos directamente desde color_palette.dart.
@immutable
class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final LinearGradient? backgroundGradient;
  final LinearGradient? cardGradient;
  AppThemeExtensions({this.backgroundGradient, this.cardGradient});

  @override
  AppThemeExtensions copyWith({
    LinearGradient? backgroundGradient,
    LinearGradient? cardGradient,
  }) {
    return AppThemeExtensions(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      cardGradient: cardGradient ?? this.cardGradient,
    );
  }

  @override
  AppThemeExtensions lerp(ThemeExtension<AppThemeExtensions>? other, double t) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    // Para simplificar, no implementamos lerp para degradados aquí.
    // En una app real, podrías interpolar los colores del degradado.
    return this;
  }
}

class AppThemes {
  static final TextTheme _darkTextTheme = buildDarkTextTheme();
  static final TextTheme _lightTextTheme = buildLightTextTheme();

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        modernDarkBackground, // Color base, el degradado se aplica encima

    colorScheme: const ColorScheme.dark(
      primary: modernDarkPrimary,
      secondary: modernDarkSecondary,
      surface: modernDarkSurface,
      background: modernDarkBackground,
      error: modernDarkError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: modernDarkText,
      onBackground: modernDarkText,
      onError: Colors.white,
    ),

    textTheme: _darkTextTheme,
    elevatedButtonTheme: modernDarkElevatedButtonTheme(_darkTextTheme),
    outlinedButtonTheme: modernDarkOutlinedButtonTheme(_darkTextTheme),
    textButtonTheme: modernDarkTextButtonTheme(_darkTextTheme),
    inputDecorationTheme: modernDarkInputDecorationTheme(_darkTextTheme),
    appBarTheme: modernDarkAppBarTheme(_darkTextTheme),
    cardTheme: modernDarkCardTheme(),
    floatingActionButtonTheme: modernDarkFloatingActionButtonTheme(),
    snackBarTheme: modernDarkSnackBarTheme(_darkTextTheme),

    iconTheme: const IconThemeData(color: modernDarkText, size: 24),
    dividerTheme: DividerThemeData(
      color: modernDarkText.withOpacity(0.2),
      thickness: 1,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? modernDarkAccent
                : modernDarkSecondaryText.withOpacity(0.6),
      ),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? modernDarkAccent.withOpacity(0.5)
                : modernDarkSurface.withOpacity(0.8),
      ),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? Colors.transparent
                : modernDarkText.withOpacity(0.3),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: modernDarkSurface,
      selectedColor: modernDarkPrimary,
      labelStyle: _darkTextTheme.bodySmall?.copyWith(color: modernDarkText),
      secondaryLabelStyle: _darkTextTheme.bodySmall?.copyWith(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconTheme: const IconThemeData(color: modernDarkText, size: 18),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtensions(
        backgroundGradient: darkGradientBackground,
        cardGradient: darkCardGradient,
      ),
    ],
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: modernLightBackground,

    colorScheme: const ColorScheme.light(
      primary: modernLightPrimary,
      secondary: modernLightSecondary,
      surface: modernLightSurface,
      background: modernLightBackground,
      error: modernLightError,
      onPrimary: Colors.white,
      onSecondary:
          Colors
              .white, // O modernLightText si el fondo del botón secundario es claro
      onSurface: modernLightText,
      onBackground: modernLightText,
      onError: Colors.white,
    ),

    textTheme: _lightTextTheme,
    elevatedButtonTheme: modernLightElevatedButtonTheme(_lightTextTheme),
    outlinedButtonTheme: modernLightOutlinedButtonTheme(_lightTextTheme),
    textButtonTheme: modernLightTextButtonTheme(_lightTextTheme),
    inputDecorationTheme: modernLightInputDecorationTheme(_lightTextTheme),
    appBarTheme: modernLightAppBarTheme(_lightTextTheme),
    cardTheme: modernLightCardTheme(),
    floatingActionButtonTheme: modernLightFloatingActionButtonTheme(),
    snackBarTheme: modernLightSnackBarTheme(_lightTextTheme),

    iconTheme: const IconThemeData(color: modernLightText, size: 24),
    dividerTheme: DividerThemeData(
      color: modernLightText.withOpacity(0.15),
      thickness: 1,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? modernLightAccent
                : modernLightSecondaryText.withOpacity(0.6),
      ),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? modernLightAccent.withOpacity(0.5)
                : modernLightSurface.withOpacity(0.8),
      ),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(MaterialState.selected)
                ? Colors.transparent
                : modernLightText.withOpacity(0.3),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: modernLightPrimary.withOpacity(0.1),
      selectedColor: modernLightPrimary,
      labelStyle: _lightTextTheme.bodySmall?.copyWith(
        color: modernLightPrimary,
      ),
      secondaryLabelStyle: _lightTextTheme.bodySmall?.copyWith(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconTheme: IconThemeData(color: modernLightPrimary, size: 18),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtensions(
        backgroundGradient: lightGradientBackground,
        cardGradient: lightCardGradient,
      ),
    ],
  );
}

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(ThemeMode value) : super(value);

  void toggleTheme() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    value = mode;
  }
}
