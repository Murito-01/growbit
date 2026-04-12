import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitItem({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        habit.title,
        style: TextStyle(
          decoration: habit.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(value: habit.isDone, onChanged: (_) => onToggle()),
    );
  }
}
