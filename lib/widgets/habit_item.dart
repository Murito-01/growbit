import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitItem({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = habit.currentStreak;

    final cardBgColor = habit.isDone
        ? (isDark ? const Color(0xFF1A2E1E) : const Color(0xFFDCFCE7))
        : Theme.of(context).cardColor;

    final checkboxFill =
        habit.isDone ? Colors.green.shade400 : Colors.transparent;
    final checkboxBorder =
        habit.isDone ? Colors.green.shade400 : cs.outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Animated Checkbox ────────────────────────────────────
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: checkboxFill,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: checkboxBorder, width: 2),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: habit.isDone
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey(true),
                        color: Colors.white,
                        size: 16,
                      )
                    : const SizedBox(key: ValueKey(false)),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ── Habit Title ───────────────────────────────────────────
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: habit.isDone ? TextDecoration.lineThrough : null,
                decorationColor: cs.onSurface.withOpacity(0.4),
                color: habit.isDone
                    ? cs.onSurface.withOpacity(0.4)
                    : cs.onSurface,
              ),
              child: Text(habit.title),
            ),
          ),

          // ── Streak Badge ─────────────────────────────────────────
          if (streak > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 2),
                  Text(
                    '$streak',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
