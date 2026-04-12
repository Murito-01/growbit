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
}
