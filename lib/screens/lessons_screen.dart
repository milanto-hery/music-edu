// lib/screens/lessons_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/music_model.dart';
import '../theme/app_theme.dart';
import '../widgets/chord_diagram.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final lessons = provider.filteredLessons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Path'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _InstrumentToggle(provider: provider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Difficulty filter bar
          _DifficultyBar(provider: provider),
          // Lessons list
          Expanded(
            child: lessons.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lessons.length,
                    itemBuilder: (ctx, i) =>
                        _LessonCard(lesson: lessons[i], index: i),
                  ),
          ),
        ],
      ),
    );
  }
}

class _InstrumentToggle extends StatelessWidget {
  final AppProvider provider;
  const _InstrumentToggle({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleBtn(
          label: '🎸',
          isActive: provider.selectedInstrument == Instrument.guitar,
          onTap: () => provider.selectInstrument(Instrument.guitar),
        ),
        const SizedBox(width: 4),
        _ToggleBtn(
          label: '🎹',
          isActive: provider.selectedInstrument == Instrument.piano,
          onTap: () => provider.selectInstrument(Instrument.piano),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _ToggleBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withOpacity(0.15) : AppTheme.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppTheme.accent : AppTheme.cardBorder,
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

class _DifficultyBar extends StatelessWidget {
  final AppProvider provider;
  const _DifficultyBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppTheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: Difficulty.values
            .map(
              (d) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DifficultyChip(
                  difficulty: d,
                  isSelected: provider.filterDifficulty == d,
                  onTap: () => provider.setFilterDifficulty(d),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final int index;
  const _LessonCard({required this.lesson, required this.index});

  static const Map<Difficulty, Color> _colors = {
    Difficulty.beginner: AppTheme.accentGreen,
    Difficulty.intermediate: AppTheme.accentBlue,
    Difficulty.advanced: AppTheme.accent,
    Difficulty.professional: AppTheme.accentRed,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[lesson.difficulty] ?? AppTheme.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: lesson.isCompleted
                ? AppTheme.accentGreen.withOpacity(0.4)
                : AppTheme.cardBorder,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: lesson.isLocked
              ? null
              : () => _showLessonDetail(context, lesson),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Step number
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: lesson.isCompleted
                        ? AppTheme.accentGreen.withOpacity(0.15)
                        : lesson.isLocked
                        ? AppTheme.cardBorder.withOpacity(0.5)
                        : color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: lesson.isCompleted
                          ? AppTheme.accentGreen
                          : lesson.isLocked
                          ? AppTheme.cardBorder
                          : color.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: lesson.isCompleted
                        ? Icon(
                            Icons.check,
                            color: AppTheme.accentGreen,
                            size: 20,
                          )
                        : lesson.isLocked
                        ? const Icon(
                            Icons.lock,
                            color: AppTheme.textSecond,
                            size: 18,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: lesson.isLocked
                                  ? AppTheme.textSecond
                                  : AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: lesson.topics
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: color.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(fontSize: 10, color: color),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Duration & arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lesson.duration,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecond,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      lesson.isLocked
                          ? Icons.lock_outline
                          : Icons.arrow_forward_ios,
                      size: 14,
                      color: lesson.isLocked
                          ? AppTheme.cardBorder
                          : AppTheme.textSecond,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLessonDetail(BuildContext context, Lesson lesson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _LessonDetailSheet(lesson: lesson),
    );
  }
}

class _LessonDetailSheet extends StatelessWidget {
  final Lesson lesson;
  const _LessonDetailSheet({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Text(lesson.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Text(
            'Topics Covered',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...lesson.topics.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppTheme.accentGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(t, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Placeholder audio
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.headphones, color: AppTheme.accent, size: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Demo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Text(
                      'Tap to listen (placeholder)',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecond,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.play_circle_filled,
                  color: AppTheme.accent,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Lesson'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎵', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('No lessons yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Try a different filter',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
