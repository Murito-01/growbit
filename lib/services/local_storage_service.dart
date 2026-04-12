import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class LocalStorageService {
  static const String habitsKey = 'habits';

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> habitsJson = habits
        .map((h) => jsonEncode(h.toJson()))
        .toList();

    await prefs.setStringList(habitsKey, habitsJson);
  }

  static Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? habitsJson = prefs.getStringList(habitsKey);

    if (habitsJson == null) return [];

    return habitsJson.map((h) => Habit.fromJson(jsonDecode(h))).toList();
  }

  static const String xpKey = 'xp';
  static const String levelKey = 'level';

  static Future<void> saveUserProgress(int xp, int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(xpKey, xp);
    await prefs.setInt(levelKey, level);
  }

  static Future<Map<String, int>> loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final xp = prefs.getInt(xpKey) ?? 0;
    final level = prefs.getInt(levelKey) ?? 1;

    return {'xp': xp, 'level': level};
  }

  static const String lastResetKey = 'last_reset_date';

  static Future<void> saveLastResetDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastResetKey, date.toIso8601String());
  }

  static Future<DateTime?> loadLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(lastResetKey);

    if (dateString == null) return null;

    return DateTime.parse(dateString);
  }
}
