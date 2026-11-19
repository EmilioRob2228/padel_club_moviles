import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static const verde = Color(0xFF2E7D5B);

  static ThemeData claroTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: verde, brightness: Brightness.light),
      fontFamily: GoogleFonts.dmSans().fontFamily,
    );
  }

  static ThemeData oscuroTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: verde, brightness: Brightness.dark),
      fontFamily: GoogleFonts.dmSans().fontFamily,
    );
  }
}
