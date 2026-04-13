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
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadHabits();
    await loadUserProgress();
    await checkDailyReset();
  }

  Future<void> loadHabits() async {
    final data = await LocalStorageService.loadHabits();
    setState(() {
      habits = data;
    });
  }

  Future<void> loadUserProgress() async {
    final data = await LocalStorageService.loadUserProgress();
    setState(() {
      userProgress.xp = data['xp']!;
      userProgress.level = data['level']!;
    });
  }

  Future<void> saveHabits() async {
    await LocalStorageService.saveHabits(habits);
  }

  Future<void> checkDailyReset() async {
    final lastReset = await LocalStorageService.loadLastResetDate();
    final now = DateTime.now();

    if (lastReset == null || !isSameDay(lastReset, now)) {
      setState(() {
        for (var habit in habits) {
          habit.isDone = false;
        }
      });

      await LocalStorageService.saveLastResetDate(now);
      await saveHabits();
    }
  }

  bool isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;

    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void addHabit(String title) {
    setState(() {
      habits.add(Habit(title: title));
    });
    saveHabits();
  }

  void toggleHabit(int index) {
    final habit = habits[index];
    final now = DateTime.now();

    setState(() {
      habit.isDone = !habit.isDone;

      if (habit.isDone) {
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

      body: Column(
        children: [
          // 🔥 HEADER (XP + LEVEL)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Progress",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Level ${userProgress.level}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "XP: ${userProgress.xp}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // 🔥 LIST HABIT
          Expanded(
            child: habits.isEmpty
                ? const Center(
                    child: Text(
                      "No habits yet.\nStart building your routine 💪",
                      textAlign: TextAlign.center,
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
}
