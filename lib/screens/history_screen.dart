import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final habits = provider.habits;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded,
                      size: 80, color: cs.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No habits to show',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some habits and start completing them!',
                    style:
                        TextStyle(color: cs.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habits.length,
              itemBuilder: (context, index) =>
                  _HabitHistoryCard(habit: habits[index]),
            ),
    );
  }
}

class _HabitHistoryCard extends StatelessWidget {
  final Habit habit;

  const _HabitHistoryCard({required this.habit});

  String _dayLabel(DateTime day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final streak = habit.currentStreak;
    final totalCompletions = habit.totalCompletions;

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // Generate last 7 days (oldest to newest)
    final last7Days = List.generate(
      7,
      (i) => todayOnly.subtract(Duration(days: 6 - i)),
    );

    final completedDays = habit.completionHistory
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + streak badge row
          Row(
            children: [
              Expanded(
                child: Text(
                  habit.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (streak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🔥 $streak day${streak == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'No streak',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Last 7 days mini-calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: last7Days.map((day) {
              final isCompleted = completedDays.contains(day);
              final isToday = day == todayOnly;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.shade400
                          : isToday
                              ? cs.primaryContainer
                              : cs.onSurface.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isCompleted
                          ? Border.all(color: cs.primary, width: 1.5)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _dayLabel(day),
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday
                          ? cs.primary
                          : cs.onSurface.withOpacity(0.5),
                      fontWeight:
                          isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 14),
          Divider(color: cs.outline.withOpacity(0.3)),
          const SizedBox(height: 8),

          // Total completions
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                'Total: $totalCompletions completion${totalCompletions == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
