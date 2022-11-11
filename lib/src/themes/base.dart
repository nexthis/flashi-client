import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTheme {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      // textTheme: _textTheme, //for custom font style
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),

        // contentTextStyle: _textTheme.titleMedium!.apply(color: _darkFillColor), //for custom font style
      ),
      useMaterial3: true,
    );
  }

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF6d64fb),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF33b7f3),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF2f2e41),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const ColorScheme whiteColorScheme = ColorScheme(
    primary: Color(0xFF6d64fb),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF33b7f3),
    secondaryContainer: Color(0xFF451B6F),
    background: Colors.white,
    surface: Colors.white30,
    onBackground: Colors.white38, // White with 0.05 opacity
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: _lightFillColor,
    onSurface: _lightFillColor,
    brightness: Brightness.light,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  //ADD some font style if you wish
  // static final TextTheme _textTheme = TextTheme(
  //   headlineMedium: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
  //   bodySmall: GoogleFonts.oswald(fontWeight: _semiBold, fontSize: 16.0),
  //   headlineSmall: GoogleFonts.oswald(fontWeight: _medium, fontSize: 16.0),
  //   titleMedium: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
  //   labelSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
  //   bodyLarge: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 14.0),
  //   titleSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
  //   bodyMedium: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
  //   titleLarge: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
  //   labelLarge: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
  // );
}
