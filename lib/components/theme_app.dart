import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static const lima = Color(0xFFDFF94B);
  static const negro = Color(0xFF0B0B0C);
  static const superficie = Color(0xFF1A1A1C);
  static const superficieAlta = Color(0xFF242427);
  static const grisTexto = Color(0xFF9A9AA0);
  static const blanco = Colors.white;
  static const grisClaro = Color(0xFFF3F4EF);
  static const grisBorde = Color(0xFFE2E2E6);

  static String? get _fuente => GoogleFonts.plusJakartaSans().fontFamily;

  static ThemeData oscuroTheme() {
    return _base(
      brightness: Brightness.dark,
      fondo: negro,
      tarjeta: superficie,
      campo: superficieAlta,
      texto: blanco,
      textoSuave: grisTexto,
      borde: superficieAlta,
    );
  }

  static ThemeData claroTheme() {
    return _base(
      brightness: Brightness.light,
      fondo: grisClaro,
      tarjeta: blanco,
      campo: blanco,
      texto: negro,
      textoSuave: const Color(0xFF6B6B72),
      borde: grisBorde,
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required Color fondo,
    required Color tarjeta,
    required Color campo,
    required Color texto,
    required Color textoSuave,
    required Color borde,
  }) {
    final colores = ColorScheme(
      brightness: brightness,
      primary: lima,
      onPrimary: negro,
      secondary: texto,
      onSecondary: fondo,
      error: const Color(0xFFFF5A5F),
      onError: blanco,
      surface: fondo,
      onSurface: texto,
      onSurfaceVariant: textoSuave,
      surfaceContainerHighest: campo,
      surfaceContainer: tarjeta,
      outline: borde,
    );

    final pildora = RoundedRectangleBorder(borderRadius: BorderRadius.circular(32));

    return ThemeData(
      colorScheme: colores,
      fontFamily: _fuente,
      scaffoldBackgroundColor: fondo,
      appBarTheme: AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontFamily: _fuente, fontSize: 22, fontWeight: FontWeight.w700, color: texto),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lima,
          foregroundColor: negro,
          disabledBackgroundColor: lima.withValues(alpha: 0.4),
          textStyle: TextStyle(fontFamily: _fuente, fontSize: 16, fontWeight: FontWeight.w700),
          shape: pildora,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: texto,
          backgroundColor: tarjeta,
          side: BorderSide.none,
          textStyle: TextStyle(fontFamily: _fuente, fontSize: 15, fontWeight: FontWeight.w600),
          shape: pildora,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: texto,
          textStyle: TextStyle(fontFamily: _fuente, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: campo,
        labelStyle: TextStyle(color: textoSuave),
        floatingLabelStyle: TextStyle(color: texto),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lima, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: tarjeta,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: texto,
        subtitleTextStyle: TextStyle(fontFamily: _fuente, color: textoSuave, fontSize: 14),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: fondo),
      dividerTheme: DividerThemeData(color: borde, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? negro : textoSuave),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? lima : campo),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: lima),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: superficieAlta,
        contentTextStyle: TextStyle(fontFamily: _fuente, color: blanco),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tarjeta,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tarjeta,
        selectedColor: lima,
        labelStyle: TextStyle(fontFamily: _fuente, color: texto, fontWeight: FontWeight.w600),
        secondaryLabelStyle: TextStyle(fontFamily: _fuente, color: negro, fontWeight: FontWeight.w600),
        side: BorderSide.none,
        shape: pildora,
      ),
    );
  }
}
