import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showAddHabitDialog(BuildContext context) {
    final controller = TextEditingController();
    final provider = Provider.of<HabitProvider>(context, listen: false);

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
                provider.addHabit(controller.text);
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
    final provider = Provider.of<HabitProvider>(context);

    final xpPerLevel = provider.xpPerLevel;
    final progress = (provider.userProgress.xp % xpPerLevel) / xpPerLevel;

    return Scaffold(
      appBar: AppBar(title: const Text("Growbit")),
      body: Column(
        children: [
          // 🔥 HEADER
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
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  "Level ${provider.userProgress.level}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "XP: ${provider.userProgress.xp}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  "${provider.userProgress.xp % xpPerLevel}/$xpPerLevel XP",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // 🔥 LIST / EMPTY
          Expanded(
            child: provider.habits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.track_changes,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No habits yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Start building your routine 💪",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => showAddHabitDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Habit"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.habits.length,
                    itemBuilder: (context, index) {
                      return HabitItem(
                        habit: provider.habits[index],
                        onToggle: () => provider.toggleHabit(index, context),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
