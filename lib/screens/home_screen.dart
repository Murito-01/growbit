import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/user_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  UserProgress userProgress = UserProgress();

  void addHabit(String title) {
    setState(() {
      habits.add(Habit(title: title));
    });
  }

  void toggleHabit(int index) {
    setState(() {
      habits[index].isDone = !habits[index].isDone;

      if (habits[index].isDone) {
        userProgress.addXP(10);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("+10 XP 🎉"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
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
            onPressed: () {
              Navigator.pop(context);
            },
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
      body: habits.isEmpty
          ? const Center(child: Text("No habits yet"))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return ListTile(
                  title: Text(habit.title),
                  leading: Checkbox(
                    value: habit.isDone,
                    onChanged: (_) => toggleHabit(index),
                  ),
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
