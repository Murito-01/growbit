import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitItem({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: habit.isDone ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔥 Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: habit.isDone ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: habit.isDone ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: habit.isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // 🔥 Title
          Expanded(
            child: Text(
              habit.title,
              style: TextStyle(
                fontSize: 16,
                decoration: habit.isDone ? TextDecoration.lineThrough : null,
                color: habit.isDone ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
