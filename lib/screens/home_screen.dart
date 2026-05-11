// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/music_model.dart';
import '../data/music_data.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 48 : 20,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 32),
              _ProgressCard(provider: provider),
              const SizedBox(height: 32),
              Text(
                'Choose Your Instrument',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Select to explore chords, scales & lessons',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: _InstrumentCard(
                            instrument: Instrument.guitar,
                            provider: provider,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _InstrumentCard(
                            instrument: Instrument.piano,
                            provider: provider,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _InstrumentCard(
                          instrument: Instrument.guitar,
                          provider: provider,
                        ),
                        const SizedBox(height: 16),
                        _InstrumentCard(
                          instrument: Instrument.piano,
                          provider: provider,
                        ),
                      ],
                    ),
              const SizedBox(height: 32),
              Text(
                'Musical Styles',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Explore genres from Pop to Jazz',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _StylesGrid(),
              const SizedBox(height: 32),
              _QuickActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppTheme.accentGrad,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.music_note, color: AppTheme.bg, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MusicEdu',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: AppTheme.accent),
            ),
            Text(
              'LEARN · PLAY · MASTER',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final AppProvider provider;
  const _ProgressCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final pct = (provider.overallProgress * 100).round();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A00), Color(0xFF2A2000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppTheme.accent),
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.completedLessons} lessons completed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: provider.overallProgress,
                    backgroundColor: AppTheme.cardBorder,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$pct% complete',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          CircleAvatar(
            radius: 36,
            backgroundColor: AppTheme.accent.withOpacity(0.1),
            child: Text(
              '$pct%',
              style: const TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  final Instrument instrument;
  final AppProvider provider;
  const _InstrumentCard({required this.instrument, required this.provider});

  bool get _isSelected => provider.selectedInstrument == instrument;
  bool get _isGuitar => instrument == Instrument.guitar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => provider.selectInstrument(instrument),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 160,
        decoration: BoxDecoration(
          gradient: _isGuitar ? AppTheme.guitarGrad : AppTheme.pianoGrad,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isSelected ? AppTheme.accent : AppTheme.cardBorder,
            width: _isSelected ? 2 : 1,
          ),
          boxShadow: _isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12,
              top: -8,
              child: Text(
                _isGuitar ? '🎸' : '🎹',
                style: const TextStyle(fontSize: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SELECTED',
                        style: TextStyle(
                          color: AppTheme.bg,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    _isGuitar ? 'Guitar' : 'Piano',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isGuitar
                        ? 'Chords, scales & tabs'
                        : 'Keys, harmony & melody',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StylesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styles = musicalStyles;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: styles.map((style) => _StyleChip(style: style)).toList(),
    );
  }
}

class _StyleChip extends StatelessWidget {
  final MusicalStyle style;
  const _StyleChip({required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(style.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: style.color,
                ),
              ),
              Text(
                style.difficulty.name,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecond,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(Icons.piano, 'Theory Engine', 'Explore keys & chords'),
      _Action(Icons.school, 'Lessons', 'Structured learning'),
      _Action(Icons.bar_chart, 'Progressions', 'Common patterns'),
      _Action(Icons.headphones, 'Audio Demos', 'Listen & play along'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Start', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 500 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: actions.map((a) => _QuickCard(action: a)).toList(),
        ),
      ],
    );
  }
}

class _Action {
  final IconData icon;
  final String title;
  final String sub;
  _Action(this.icon, this.title, this.sub);
}

class _QuickCard extends StatelessWidget {
  final _Action action;
  const _QuickCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(action.icon, color: AppTheme.accent, size: 26),
          const Spacer(),
          Text(
            action.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            action.sub,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
