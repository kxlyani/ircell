import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  // Main colors - now split into light and dark variants
  static const Color primaryDarkBlue = Color(0xFF0A1E3D); // Deep dark blue
  static const Color accentBlue = Color(
    0xFF1A73E8,
  ); // Bright teal for highlights
  static const Color darkTeal = Color(0xFF00BFA5); // Darker teal
  static const Color darkBackground = Color(0xFF121212); // Dark background
  static const Color darkCardColor = Color(
    0xFF1E293B,
  ); // Card/dark surface color
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(
    0xFF94A3B8,
  ); // Muted blue-gray text

  // Light theme colors
  static const Color lightPrimaryBlue = Color(0xFFE3F2FD); // Light blue
  static const Color lightAccentBlue = Color(
    0xFF1976D2,
  ); // Darker blue for accents
  static const Color lightTeal = Color(0xFF00ACC1); // Muted teal
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color lightCardColor = Colors.white; // Card color
  static const Color lightTextPrimary = Color(0xFF212121); // Dark gray
  static const Color lightTextSecondary = Color(0xFF757575); // Medium gray

  // Get the appropriate theme based on brightness
  static ThemeData get theme {
    return buildTheme(Brightness.dark); // Default to dark
  }

  // This allows the app to respond to system theme changes
  static ThemeData themeData(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return buildTheme(brightness);
  }

  static ThemeData buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      primaryColor: isDark ? primaryDarkBlue : lightPrimaryBlue,
      scaffoldBackgroundColor: isDark ? darkBackground : lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: isDark ? primaryDarkBlue : lightPrimaryBlue,
        primary: isDark ? primaryDarkBlue : lightPrimaryBlue,
        secondary: isDark ? accentBlue : lightAccentBlue,
        surface: isDark ? darkCardColor : lightCardColor,
        onPrimary: isDark ? darkTextPrimary : lightTextPrimary,
        onSecondary: isDark ? darkTextPrimary : lightTextPrimary,
        onSurface: isDark ? darkTextPrimary : lightTextPrimary,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: isDark ? darkTextPrimary : lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: isDark ? darkTextPrimary : lightTextPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white.withOpacity(0.2) : Colors.black,
        thickness: 1,
        space: 1,
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDark ? darkTextPrimary : lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: isDark ? darkTextPrimary : lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: isDark ? darkTextPrimary : lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(
          color: isDark ? darkTextPrimary : lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: isDark ? darkTextSecondary : lightTextSecondary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? accentBlue : lightAccentBlue,
          foregroundColor: isDark ? darkTextPrimary : lightTextPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? darkCardColor : lightCardColor,
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkCardColor.withOpacity(0.8) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? darkCardColor : lightCardColor,
        selectedItemColor: isDark ? accentBlue : lightAccentBlue,
        unselectedItemColor: isDark ? darkTextSecondary : lightTextSecondary,
        elevation: 8,
      ),
    );
  }

  // Background gradient - now adapts to theme
  static LinearGradient blueGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LinearGradient(
      colors:
          isDark
              ? const [primaryDarkBlue, Color(0xFF1E3A8A), accentBlue]
              : const [lightPrimaryBlue, Color(0xFF90CAF9), lightAccentBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Reusable decoration for screens with gradient background
  static BoxDecoration gradientBackground(BuildContext context) {
    return BoxDecoration(gradient: blueGradient(context));
  }

  // Card decoration with surface color and rounded corners
  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark ? darkCardColor : lightCardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static Color cardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkCardColor : lightCardColor;
  }

  static Color textPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkTextPrimary : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkTextSecondary : lightTextSecondary;
  }

  static Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBackground : lightBackground;
  }

  // Glassmorphism effect decoration
  static BoxDecoration glassDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color:
          isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.1 : 0.05),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
}

class ThemeController {
  static final ValueNotifier<ThemeMode> themeModeNotifier = 
      ValueNotifier(ThemeMode.system);

  static const String _themeKey = 'selected_theme';

  static Future<void> setThemeMode(ThemeMode mode) async {
    // Update the notifier first for immediate UI change
    themeModeNotifier.value = mode;
    // Then save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString().split('.').last);
  }

  static Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_themeKey);
    
    ThemeMode mode;
    switch (themeStr) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'system':
      default:
        mode = ThemeMode.system;
        break;
    }
    themeModeNotifier.value = mode;
  }
}