import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()..init()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
      ],
      child: const GrowbitApp(),
    ),
  );
}

class GrowbitApp extends StatelessWidget {
  const GrowbitApp({super.key});

  static const Color _seed = Color(0xFF6366F1); // Indigo

  static final _lightScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  );

  static final _darkScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  );

  static final _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightScheme,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    scaffoldBackgroundColor: const Color(0xFFF3F4FF),
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF3F4FF),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: _lightScheme.onSurface),
      titleTextStyle: GoogleFonts.outfit(
        color: _lightScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
  );

  static final _darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkScheme,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: const Color(0xFF0F0F1A),
    cardColor: const Color(0xFF1C1C2E),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F0F1A),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: _darkScheme.onSurface),
      titleTextStyle: GoogleFonts.outfit(
        color: _darkScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Growbit',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
    );
  }
}
