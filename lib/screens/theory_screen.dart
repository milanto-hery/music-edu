// lib/screens/theory_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/music_model.dart';
import '../data/music_data.dart';
import '../theme/app_theme.dart';
import '../widgets/chord_diagram.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theory Engine'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text(
                provider.selectedInstrument == Instrument.guitar
                    ? '🎸 Guitar'
                    : '🎹 Piano',
              ),
              backgroundColor: AppTheme.card,
              side: const BorderSide(color: AppTheme.cardBorder),
            ),
          ),
        ],
      ),
      body: isWide
          ? Row(
              children: [
                SizedBox(width: 260, child: _KeySidebar()),
                const VerticalDivider(width: 1, color: AppTheme.cardBorder),
                Expanded(child: _TheoryContent()),
              ],
            )
          : Column(
              children: [
                _KeyHorizontalSelector(),
                Expanded(child: _TheoryContent()),
              ],
            ),
    );
  }
}

// ── Key Sidebar (wide layout) ─────────────────────────────────────────────

class _KeySidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Container(
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Key',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allKeys.length,
              itemBuilder: (ctx, i) {
                final key = allKeys[i];
                final isSelected = provider.selectedKey.name == key.name;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: AppTheme.accent.withOpacity(0.1),
                  leading: _KeyBadge(keyName: key.name, sharps: key.sharps),
                  title: Text(
                    key.fullName,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.accent
                          : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    key.sharps == 0
                        ? 'No accidentals'
                        : key.sharps > 0
                        ? '${key.sharps} sharp${key.sharps > 1 ? "s" : ""}'
                        : '${key.sharps.abs()} flat${key.sharps.abs() > 1 ? "s" : ""}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecond,
                    ),
                  ),
                  onTap: () => provider.selectKey(key),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Key Horizontal Selector (narrow layout) ───────────────────────────────

class _KeyHorizontalSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Container(
      height: 64,
      color: AppTheme.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: allKeys.length,
        itemBuilder: (ctx, i) {
          final key = allKeys[i];
          final isSelected = provider.selectedKey.name == key.name;
          return GestureDetector(
            onTap: () => provider.selectKey(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.accent : AppTheme.cardBorder,
                ),
              ),
              child: Text(
                key.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppTheme.bg : AppTheme.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KeyBadge extends StatelessWidget {
  final String keyName;
  final int sharps;
  const _KeyBadge({required this.keyName, required this.sharps});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.majorCol,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          keyName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Theory Content (main area) ────────────────────────────────────────────

class _TheoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final key = provider.selectedKey;
    final isGuitar = provider.selectedInstrument == Instrument.guitar;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key header
          _KeyHeader(musicKey: key),
          const SizedBox(height: 24),

          // Scale notes
          Text(
            'Scale Notes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'The 8 notes of ${key.fullName}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _ScaleNotes(musicKey: key),
          const SizedBox(height: 28),

          // Chord degrees
          Text(
            'Chord Degrees',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a chord to see its diagram',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _DegreeRow(musicKey: key, provider: provider),
          const SizedBox(height: 24),

          // Chord grid
          _ChordGrid(musicKey: key, provider: provider, isGuitar: isGuitar),
          const SizedBox(height: 28),

          // Audio demo section
          Text(
            'Audio Demos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          _AudioSection(musicKey: key, provider: provider),
        ],
      ),
    );
  }
}

class _KeyHeader extends StatelessWidget {
  final MusicKey musicKey;
  const _KeyHeader({required this.musicKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.majorCol.withOpacity(0.4),
            AppTheme.majorCol.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.majorCol.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                musicKey.fullName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _InfoPill(
                    label: musicKey.sharps == 0
                        ? 'Natural'
                        : musicKey.sharps > 0
                        ? '${musicKey.sharps}♯'
                        : '${musicKey.sharps.abs()}♭',
                    color: AppTheme.accentBlue,
                  ),
                  const SizedBox(width: 8),
                  _InfoPill(
                    label: 'Rel. ♭ ${musicKey.relativeMinor}',
                    color: AppTheme.minorCol,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 260,
                child: Text(
                  musicKey.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ScaleNotes extends StatelessWidget {
  final MusicKey musicKey;
  const _ScaleNotes({required this.musicKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: musicKey.scale.length,
        separatorBuilder: (_, __) =>
            const Icon(Icons.arrow_right, color: AppTheme.cardBorder, size: 16),
        itemBuilder: (ctx, i) {
          final note = musicKey.scale[i];
          final isRoot = i == 0 || i == musicKey.scale.length - 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isRoot
                      ? AppTheme.accent.withOpacity(0.15)
                      : note.isBlackKey
                      ? AppTheme.card
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isRoot ? AppTheme.accent : AppTheme.cardBorder,
                    width: isRoot ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      note.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isRoot ? AppTheme.accent : AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppTheme.textSecond,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DegreeRow extends StatelessWidget {
  final MusicKey musicKey;
  final AppProvider provider;
  const _DegreeRow({required this.musicKey, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: musicKey.degrees.asMap().entries.map((entry) {
          final i = entry.key;
          final deg = entry.value;
          return GestureDetector(
            onTap: () => provider.selectDegree(i),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DegreeBadge(
                numeral: deg.romanNumeral,
                type: deg.type,
                isSelected: provider.selectedDegreeIndex == i,
                function: deg.function,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChordGrid extends StatelessWidget {
  final MusicKey musicKey;
  final AppProvider provider;
  final bool isGuitar;
  const _ChordGrid({
    required this.musicKey,
    required this.provider,
    required this.isGuitar,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: musicKey.degrees.asMap().entries.map((entry) {
        final i = entry.key;
        final deg = entry.value;
        final isSelected = provider.selectedDegreeIndex == i;
        return _ChordCard(
          degree: deg,
          isSelected: isSelected,
          isGuitar: isGuitar,
          provider: provider,
          onTap: () => provider.selectDegree(i),
          cardWidth: isWide ? 150 : 130,
        );
      }).toList(),
    );
  }
}

class _ChordCard extends StatelessWidget {
  final ScaleDegree degree;
  final bool isSelected;
  final bool isGuitar;
  final AppProvider provider;
  final VoidCallback onTap;
  final double cardWidth;

  const _ChordCard({
    required this.degree,
    required this.isSelected,
    required this.isGuitar,
    required this.provider,
    required this.onTap,
    required this.cardWidth,
  });

  Color get _headerColor {
    return degree.type == ChordType.major
        ? AppTheme.majorCol
        : degree.type == ChordType.minor
        ? AppTheme.minorCol
        : AppTheme.dimCol;
  }

  String get _typeLabel {
    switch (degree.type) {
      case ChordType.major:
        return 'Major';
      case ChordType.minor:
        return 'Minor';
      case ChordType.diminished:
        return 'Dim';
    }
  }

  @override
  Widget build(BuildContext context) {
    final voicing = isGuitar
        ? provider.getVoicingForChord(degree.chordName)
        : null;
    final pianoSemitones = pianoIntervals[degree.type] ?? [0, 4, 7];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _headerColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    degree.chordName,
                    style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    degree.romanNumeral,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2, top: 2),
              child: Text(
                _typeLabel,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.textSecond,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            // Diagram
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: isGuitar && voicing != null
                    ? GuitarChordDiagram(voicing: voicing, size: cardWidth - 24)
                    : PianoChordDiagram(
                        semitones: pianoSemitones,
                        rootNote: degree.chordName,
                        type: degree.type,
                        width: cardWidth - 24,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: Text(
                degree.function,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.textSecond,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioSection extends StatelessWidget {
  final MusicKey musicKey;
  final AppProvider provider;
  const _AudioSection({required this.musicKey, required this.provider});

  @override
  Widget build(BuildContext context) {
    final demos = [
      '${musicKey.name} Major Scale',
      '${musicKey.name} Chord Arpeggio',
      '${musicKey.name} I-IV-V Progression',
    ];
    return Column(
      children: demos.map((d) {
        final isPlaying = provider.audioPlaying && provider.currentAudioId == d;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AudioPlayerWidget(
            label: d,
            isPlaying: isPlaying,
            onTap: () => provider.toggleAudio(d),
          ),
        );
      }).toList(),
    );
  }
}
