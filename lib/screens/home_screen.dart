import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/user_progress.dart';
import '../services/local_storage_service.dart';
import '../widgets/habit_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  UserProgress userProgress = UserProgress();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  // 🔹 Load data saat app dibuka
  Future<void> loadHabits() async {
    final data = await LocalStorageService.loadHabits();
    setState(() {
      habits = data;
    });
  }

  // 🔹 Simpan data setiap berubah
  Future<void> saveHabits() async {
    await LocalStorageService.saveHabits(habits);
  }

  // 🔹 Tambah habit
  void addHabit(String title) {
    setState(() {
      habits.add(Habit(title: title));
    });
    saveHabits();
  }

  // 🔹 Toggle habit + XP
  void toggleHabit(int index) {
    setState(() {
      habits[index].isDone = !habits[index].isDone;

      if (habits[index].isDone) {
        userProgress.addXP(10);
      }
    });
    saveHabits();
  }

  // 🔹 Dialog tambah habit
  void showAddHabitDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Habit"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter habit..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                addHabit(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // 🔹 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Growbit"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Level ${userProgress.level} • XP: ${userProgress.xp}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),

      // 🔥 BODY UTAMA
      body: habits.isEmpty
          ? const Center(
              child: Text("No habits yet", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitItem(
                  habit: habits[index],
                  onToggle: () => toggleHabit(index),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
