class Habit {
  final String title;
  bool isDone;
  DateTime? lastCompletedDate;
  List<DateTime> completionHistory;

  Habit({
    required this.title,
    this.isDone = false,
    this.lastCompletedDate,
    List<DateTime>? completionHistory,
  }) : completionHistory = completionHistory ?? [];

  /// Returns the current consecutive-day streak.
  int get currentStreak {
    if (completionHistory.isEmpty) return 0;

    final uniqueDays = completionHistory
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // Streak is broken if last completion was more than 1 day ago
    if (todayOnly.difference(uniqueDays.first).inDays > 1) return 0;

    int streak = 0;
    DateTime check = uniqueDays.first;

    for (final day in uniqueDays) {
      if (day == check) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Returns the total number of unique completion days.
  int get totalCompletions {
    return completionHistory
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .length;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'completionHistory':
          completionHistory.map((d) => d.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final historyRaw = json['completionHistory'] as List<dynamic>?;
    return Habit(
      title: json['title'],
      isDone: json['isDone'],
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.parse(json['lastCompletedDate'])
          : null,
      completionHistory: historyRaw != null
          ? historyRaw.map((d) => DateTime.parse(d as String)).toList()
          : [],
    );
  }
}
