import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Futuristic Colors - 2080 Style
  static const Color primaryPink = Color(0xFFFF0080);
  static const Color lightPink = Color(0xFFFF4DA6);
  static const Color darkPink = Color(0xFFCC0066);
  static const Color accentPurple = Color(0xFF8A2BE2);
  static const Color lightPurple = Color(0xFFB347D9);
  static const Color roseGold = Color(0xFFE8B4B8);
  static const Color softWhite = Color(0xFFFFFBFE);
  static const Color darkGrey = Color(0xFF1A1A1A);
  
  // Futuristic Neon Colors
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color holographicBlue = Color(0xFF4CC9F0);
  static const Color holographicPurple = Color(0xFF7209B7);
  static const Color glowWhite = Color(0xFFF8F9FA);
  static const Color metallicGray = Color(0xFF495057);
  static const Color deepSpace = Color(0xFF0D1117);
  static const Color cosmicPurple = Color(0xFF161B22);

  // Light Theme - Futuristic 2080
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: neonPink,
        secondary: neonPurple,
        tertiary: neonBlue,
        surface: glowWhite,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: deepSpace,
        background: Color(0xFFF0F2F5),
        onBackground: deepSpace,
        surfaceVariant: Color(0xFFE3F2FD),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: const Color(0xFFF0F2F5),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: deepSpace,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: deepSpace),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Text Theme - Futuristic Fonts
      textTheme: GoogleFonts.orbitronTextTheme().copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: deepSpace,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: deepSpace,
          letterSpacing: 1.2,
        ),
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: deepSpace,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepSpace,
          letterSpacing: 0.8,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: deepSpace,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: deepSpace,
          letterSpacing: 0.3,
        ),
      ),

      // Card Theme - Glassmorphism
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white.withOpacity(0.7),
        shadowColor: neonPink.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme - Futuristic
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPink,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: neonPink.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
      ),

      // Input Decoration Theme - Glassmorphism
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: neonPink,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          color: deepSpace,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: neonPink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Dark Theme - Futuristic 2080
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
        secondary: neonPurple,
        tertiary: neonBlue,
        surface: cosmicPurple,
        background: deepSpace,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: glowWhite,
        onBackground: glowWhite,
        surfaceVariant: Color(0xFF21262D),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: deepSpace,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: glowWhite,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: glowWhite),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // Text Theme
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: glowWhite,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: glowWhite,
          letterSpacing: 1.2,
        ),
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: glowWhite,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: glowWhite,
          letterSpacing: 0.8,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: glowWhite,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: glowWhite,
          letterSpacing: 0.3,
        ),
      ),

      // Card Theme - Dark Glassmorphism
      cardTheme: CardTheme(
        elevation: 0,
        color: cosmicPurple.withOpacity(0.8),
        shadowColor: neonPink.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: neonBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPink,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: neonPink.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cosmicPurple.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: neonBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: neonPink,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          color: glowWhite,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: neonPink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Theme Provider
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Locale Provider
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA');

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    _locale = _locale.languageCode == 'ar'
        ? const Locale('en', 'US')
        : const Locale('ar', 'SA');
    notifyListeners();
  }
}