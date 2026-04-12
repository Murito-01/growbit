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
    loadUserProgress();
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
    final habit = habits[index];
    final now = DateTime.now();

    setState(() {
      habit.isDone = !habit.isDone;

      if (habit.isDone) {
        // ❗ Cek apakah sudah pernah dapat XP hari ini
        if (!isSameDay(habit.lastCompletedDate, now)) {
          userProgress.addXP(10);
          habit.lastCompletedDate = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("+10 XP 🎉"),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });

    saveHabits();
    LocalStorageService.saveUserProgress(userProgress.xp, userProgress.level);
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
      body: Column(
        children: [
          // 🔹 DEBUG XP (sementara, nanti bisa dihapus)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Level ${userProgress.level} • XP: ${userProgress.xp}",
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // 🔹 LIST HABIT
          Expanded(
            child: habits.isEmpty
                ? const Center(
                    child: Text(
                      "No habits yet",
                      style: TextStyle(fontSize: 16),
                    ),
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
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> loadUserProgress() async {
    final data = await LocalStorageService.loadUserProgress();

    setState(() {
      userProgress.xp = data['xp']!;
      userProgress.level = data['level']!;
    });
  }

  bool isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;

    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
