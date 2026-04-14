import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitItem({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      transform: habit.isDone
          ? (Matrix4.identity()..scale(1.02))
          : Matrix4.identity(),
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
          // 🔥 Checkbox dengan animasi
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: habit.isDone
                      ? const Icon(
                          Icons.check,
                          key: ValueKey(true),
                          color: Colors.white,
                          size: 18,
                        )
                      : const SizedBox(key: ValueKey(false)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 🔥 Title
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 16,
                decoration: habit.isDone ? TextDecoration.lineThrough : null,
                color: habit.isDone ? Colors.grey : Colors.black,
              ),
              child: Text(habit.title),
            ),
          ),
        ],
      ),
    );
  }
}
