// lib/screens/progressions_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/music_data.dart';
import '../theme/app_theme.dart';

// Common chord progressions data
const List<Map<String, dynamic>> _progressions = [
  {
    'name': 'The Axis',
    'numerals': ['I', 'V', 'vi', 'IV'],
    'key': 'G',
    'chords': ['G', 'D', 'Em', 'C'],
    'genre': 'Pop / Rock',
    'songs': ['Let Her Go', 'No Woman No Cry', 'Don\'t Stop Believin\''],
    'description':
        'Used in thousands of pop hits. The most common progression in modern music.',
    'color': 0xFF3D8EF0,
  },
  {
    'name': '12-Bar Blues',
    'numerals': [
      'I',
      'IV',
      'I',
      'I',
      'IV',
      'IV',
      'I',
      'I',
      'V',
      'IV',
      'I',
      'V',
    ],
    'key': 'A',
    'chords': ['A', 'D', 'A', 'A', 'D', 'D', 'A', 'A', 'E', 'D', 'A', 'E'],
    'genre': 'Blues / Rock',
    'songs': ['Johnny B. Goode', 'La Grange', 'Pride and Joy'],
    'description':
        'The DNA of blues. 12 bars repeated. Endless variations possible.',
    'color': 0xFFE8A020,
  },
  {
    'name': 'Jazz ii-V-I',
    'numerals': ['ii', 'V', 'I'],
    'key': 'G',
    'chords': ['Am7', 'D7', 'Gmaj7'],
    'genre': 'Jazz',
    'songs': ['Autumn Leaves', 'Fly Me to the Moon', 'Girl from Ipanema'],
    'description':
        'The most fundamental jazz progression. Strongest harmonic resolution in music.',
    'color': 0xFFBB86FC,
  },
  {
    'name': 'Canon Progression',
    'numerals': ['I', 'V', 'vi', 'iii', 'IV', 'I', 'IV', 'V'],
    'key': 'G',
    'chords': ['G', 'D', 'Em', 'Bm', 'C', 'G', 'C', 'D'],
    'genre': 'Classical / Pop',
    'songs': ['Pachelbel\'s Canon', 'Memories (Maroon 5)', 'Go West'],
    'description':
        'A descending bass line creates beautiful, inevitable movement.',
    'color': 0xFFFFB347,
  },
  {
    'name': 'I-IV-V',
    'numerals': ['I', 'IV', 'V'],
    'key': 'G',
    'chords': ['G', 'C', 'D'],
    'genre': 'Folk / Country',
    'songs': ['Knockin\' on Heaven\'s Door', 'Country Roads', 'La Bamba'],
    'description':
        'Simple, honest, powerful. The tonic-subdominant-dominant trinity.',
    'color': 0xFF2DBD6E,
  },
  {
    'name': 'vi-IV-I-V',
    'numerals': ['vi', 'IV', 'I', 'V'],
    'key': 'G',
    'chords': ['Em', 'C', 'G', 'D'],
    'genre': 'Pop / Indie',
    'songs': ['Despacito', 'Stay (Rihanna)', 'Someone Like You'],
    'description':
        'Starts on the minor 6th — slightly darker feel than the Axis. Still massively popular.',
    'color': 0xFFE05252,
  },
];

class ProgressionsScreen extends StatefulWidget {
  const ProgressionsScreen({super.key});

  @override
  State<ProgressionsScreen> createState() => _ProgressionsScreenState();
}

class _ProgressionsScreenState extends State<ProgressionsScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final prog = _progressions[_selected];
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Chord Progressions')),
      body: isWide
          ? Row(
              children: [
                SizedBox(
                  width: 280,
                  child: _ProgSidebar(
                    selected: _selected,
                    onSelect: (i) => setState(() => _selected = i),
                  ),
                ),
                const VerticalDivider(width: 1, color: AppTheme.cardBorder),
                Expanded(child: _ProgDetail(prog: prog)),
              ],
            )
          : Column(
              children: [
                _ProgHorizontalList(
                  selected: _selected,
                  onSelect: (i) => setState(() => _selected = i),
                ),
                Expanded(child: _ProgDetail(prog: prog)),
              ],
            ),
    );
  }
}

class _ProgSidebar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _ProgSidebar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _progressions.length,
        itemBuilder: (ctx, i) {
          final p = _progressions[i];
          final col = Color(p['color'] as int);
          final isSelected = selected == i;
          return ListTile(
            selected: isSelected,
            selectedTileColor: col.withOpacity(0.1),
            leading: Container(
              width: 8,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? col : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              p['name'] as String,
              style: TextStyle(
                color: isSelected ? col : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              p['genre'] as String,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecond),
            ),
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _ProgHorizontalList extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _ProgHorizontalList({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppTheme.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: _progressions.length,
        itemBuilder: (ctx, i) {
          final p = _progressions[i];
          final col = Color(p['color'] as int);
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? col.withOpacity(0.15) : AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? col : AppTheme.cardBorder,
                ),
              ),
              child: Text(
                p['name'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? col : AppTheme.textPrimary,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgDetail extends StatelessWidget {
  final Map<String, dynamic> prog;
  const _ProgDetail({required this.prog});

  @override
  Widget build(BuildContext context) {
    final col = Color(prog['color'] as int);
    final chords = List<String>.from(prog['chords'] as List);
    final numerals = List<String>.from(prog['numerals'] as List);
    final songs = List<String>.from(prog['songs'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: col.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: col.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        prog['name'] as String,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: col.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: col.withOpacity(0.3)),
                      ),
                      child: Text(
                        prog['genre'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: col,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  prog['description'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Chord flow
          Text('Chord Flow', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(chords.length, (i) {
                return Row(
                  children: [
                    _ChordFlowCard(
                      chord: chords[i],
                      numeral: numerals[i],
                      color: col,
                      index: i,
                    ),
                    if (i < chords.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward,
                          color: col.withOpacity(0.4),
                          size: 18,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Famous songs
          Text(
            'Famous Songs',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ...songs.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.music_note, color: col, size: 16),
                    const SizedBox(width: 10),
                    Text(s, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Audio demo
          Text('Demo', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_filled, color: col, size: 40),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${prog['name']} Demo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Text(
                      'Audio playback placeholder',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecond,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Fake waveform
                Row(
                  children: List.generate(
                    14,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 3,
                      height:
                          (i % 3 == 0
                                  ? 18
                                  : i % 2 == 0
                                  ? 10
                                  : 24)
                              .toDouble(),
                      decoration: BoxDecoration(
                        color: col.withOpacity(0.3 + (i % 3) * 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordFlowCard extends StatelessWidget {
  final String chord;
  final String numeral;
  final Color color;
  final int index;
  const _ChordFlowCard({
    required this.chord,
    required this.numeral,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            numeral,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chord,
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 20,
              color: color,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Beat ${index + 1}',
            style: const TextStyle(fontSize: 9, color: AppTheme.textSecond),
          ),
        ],
      ),
    );
  }
}
