import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitProvider()..init(),
      child: const GrowbitApp(),
    ),
  );
}

class GrowbitApp extends StatelessWidget {
  const GrowbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growbit',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Growbit")),
      body: const Center(
        child: Text("Growbit is Ready 🚀", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
