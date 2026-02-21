
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myapp/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Light Theme --- 
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0EA5A4), // Primary: Teal
        brightness: Brightness.light,
        primary: const Color(0xFF0EA5A4),
        secondary: const Color(0xFF84CC16), // Accent: Lime
        background: const Color(0xFFF1F5F9), // Light Background: Slate
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: const Color(0xFF0F172A), // Dark Text: Slate
        onSurface: const Color(0xFF0F172A),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: const Color(0xFF0F172A),
        displayColor: const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A), // Dark Slate for App Bar
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0EA5A4), // Teal for active tab
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0EA5A4), // Teal
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );

    // --- Dark Theme ---
    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0EA5A4), // Primary: Teal
        brightness: Brightness.dark,
        primary: const Color(0xFF0EA5A4),
        secondary: const Color(0xFF84CC16), // Accent: Lime
        background: const Color(0xFF0F172A), // Dark Background
        surface: const Color(0xFF1E293B), // Slightly lighter surface
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onBackground: const Color(0xFFF1F5F9), // Light text
        onSurface: const Color(0xFFF1F5F9),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: const Color(0xFFF1F5F9),
        displayColor: const Color(0xFFF1F5F9),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B), // Surface color
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: Color(0xFF0EA5A4), // Teal
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
         showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E293B),
      ),
       elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0EA5A4), // Teal
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );

    return MaterialApp(
      title: 'FitTrack Mini',
      theme: lightTheme, // Set default theme
      darkTheme: darkTheme, // Set dark theme
      themeMode: ThemeMode.system, // Automatically adapt to system settings
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
