// theme/dark_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static const _background = Colors.black; // almost‑black
  static const _surface = Color(0xFF1A1A1E); // cards / bars
  static const _primary = Color(0xFF006BFF); // bright blue accents
  static const _onPrimary = Colors.white;
  static const _onSurfaceDim = Colors.white70;
  static const _error = Color(0xFFCF6679);

  static final dark = ThemeData(
    useMaterial3: true, // M3 widgets, typography, motion
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _background,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _primary,
      onPrimary: _onPrimary,
      surface: _surface,
      onSurface: _onSurfaceDim,
      background: _background,
      onBackground: Colors.white,
      error: _error,
    ),

    //* App Bar */
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      systemOverlayStyle:
          SystemUiOverlayStyle.light, // status‑bar icons → light
    ),

    //* Bottom Nav */
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surface,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primary,
      unselectedItemColor: _onSurfaceDim,
      selectedIconTheme: IconThemeData(size: 26),
      unselectedIconTheme: IconThemeData(size: 24),
      showUnselectedLabels: true,
    ),

    //* Buttons */
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: _onPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return _surface; // pale button when “Scanning…”
          }
          return _primary;
        }),
        foregroundColor: WidgetStateProperty.all(_onPrimary),
      ),
    ),

    //* Cards / Dialogs */
    cardTheme: CardThemeData(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    //* Inputs & Search */
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: _onSurfaceDim,
    ),

    //* Text */
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

    iconTheme: const IconThemeData(color: _onSurfaceDim),
    dividerColor: Colors.white10,
  );
}
