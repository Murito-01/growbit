import 'package:flutter/material.dart';

void main() {
  runApp(const GrowbitApp());
}

class GrowbitApp extends StatelessWidget {
  const GrowbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growbit',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
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
