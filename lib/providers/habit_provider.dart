import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/user_progress.dart';
import '../services/local_storage_service.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> habits = [];
  UserProgress userProgress = UserProgress();

  final int xpPerLevel = 100;

  Future<void> init() async {
    await loadHabits();
    await loadUserProgress();
    await checkDailyReset();
  }

  Future<void> loadHabits() async {
    habits = await LocalStorageService.loadHabits();
    notifyListeners();
  }

  Future<void> loadUserProgress() async {
    final data = await LocalStorageService.loadUserProgress();
    userProgress.xp = data['xp']!;
    userProgress.level = data['level']!;
    notifyListeners();
  }

  Future<void> saveHabits() async {
    await LocalStorageService.saveHabits(habits);
  }

  Future<void> checkDailyReset() async {
    final lastReset = await LocalStorageService.loadLastResetDate();
    final now = DateTime.now();

    if (lastReset == null || !isSameDay(lastReset, now)) {
      for (var habit in habits) {
        habit.isDone = false;
      }
      await LocalStorageService.saveLastResetDate(now);
      await saveHabits();
      notifyListeners();
    }
  }

  bool isSameDay(DateTime? d1, DateTime d2) {
    if (d1 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void addHabit(String title) {
    habits.add(Habit(title: title));
    saveHabits();
    notifyListeners();
  }

  void toggleHabit(int index, BuildContext context) {
    final habit = habits[index];
    final now = DateTime.now();

    habit.isDone = !habit.isDone;

    if (habit.isDone) {
      if (!isSameDay(habit.lastCompletedDate, now)) {
        final oldLevel = userProgress.level;
        userProgress.addXP(10);
        habit.lastCompletedDate = now;
        habit.completionHistory.add(now); // Record history

        final newLevel = userProgress.level;
        final isLevelUp = newLevel > oldLevel;

        final message =
            isLevelUp ? '🎉 Level Up! You\'re now Level $newLevel!' : '⚡ +10 XP gained!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    saveHabits();
    LocalStorageService.saveUserProgress(userProgress.xp, userProgress.level);
    notifyListeners();
  }
}
