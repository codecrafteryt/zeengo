import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';
import 'my_color.dart';
import 'my_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _accent = MyColors.darkPurple;

  static ThemeData light() => _base(
        brightness: Brightness.light,
        palette: AppPalette.light,
        scaffold: AppPalette.light.scaffold,
        surface: AppPalette.light.card,
        onSurface: AppPalette.light.textPrimary,
      );

  static ThemeData dark() => _base(
        brightness: Brightness.dark,
        palette: AppPalette.dark,
        scaffold: MyColors.darkBg,
        surface: AppPalette.dark.card,
        onSurface: AppPalette.dark.textPrimary,
      );

  static ThemeData _base({
    required Brightness brightness,
    required AppPalette palette,
    required Color scaffold,
    required Color surface,
    required Color onSurface,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: brightness,
      surface: surface,
      onSurface: onSurface,
    ).copyWith(
      primary: _accent,
      onPrimary: Colors.white,
      surfaceContainerHighest: palette.cardMuted,
      outline: palette.border,
    );

    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: MyFonts.roboto,
          bodyColor: onSurface,
          displayColor: onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: MyFonts.roboto,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      canvasColor: scaffold,
      cardColor: surface,
      dividerColor: palette.divider,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: MyFonts.roboto,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.navBar,
        selectedItemColor: _accent,
        unselectedItemColor: isDark ? Colors.white70 : Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        hintStyle: TextStyle(
          fontFamily: MyFonts.roboto,
          color: palette.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _accent, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 50),
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: MyFonts.roboto,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size(0, 50),
          shape: const StadiumBorder(),
          side: BorderSide(color: onSurface),
          textStyle: const TextStyle(
            fontFamily: MyFonts.roboto,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1F1F1F) : const Color(0xFF323232),
        contentTextStyle: const TextStyle(
          fontFamily: MyFonts.roboto,
          color: Colors.white,
        ),
      ),
      extensions: [palette],
    );
  }
}
