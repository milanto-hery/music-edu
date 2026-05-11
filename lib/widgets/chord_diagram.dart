// lib/widgets/chord_diagram.dart
import 'package:flutter/material.dart';
import '../models/music_model.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════
//  GUITAR CHORD DIAGRAM
// ═══════════════════════════════════════════════════════════════

class GuitarChordDiagram extends StatelessWidget {
  final GuitarVoicing voicing;
  final double size;

  const GuitarChordDiagram({super.key, required this.voicing, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.15,
      child: CustomPaint(painter: _GuitarDiagramPainter(voicing: voicing)),
    );
  }
}

class _GuitarDiagramPainter extends CustomPainter {
  final GuitarVoicing voicing;
  _GuitarDiagramPainter({required this.voicing});

  @override
  void paint(Canvas canvas, Size size) {
    final frets = voicing.frets;
    final fingers = voicing.fingers;
    final barreAt = voicing.barreAt;

    const numStrings = 6;
    const numFrets = 5;

    final activeFrets = frets.where((f) => f > 0).toList();
    final minFret = activeFrets.isEmpty
        ? 1
        : activeFrets.reduce((a, b) => a < b ? a : b);
    final startFret = minFret > 1 ? minFret - 1 : 0;

    final x0 = size.width * 0.14;
    final y0 = size.height * 0.18;
    final strW = (size.width * 0.72) / (numStrings - 1);
    final fretH = (size.height * 0.70) / numFrets;

    // Colors
    final nutPaint = Paint()
      ..color = const Color(0xFF8A6A30)
      ..strokeWidth = 3;
    final fretPaint = Paint()
      ..color = AppTheme.cardBorder
      ..strokeWidth = 0.8;
    final stringPaint = Paint()
      ..color = AppTheme.textSecond.withOpacity(0.5)
      ..strokeWidth = 0.7;
    final dotColor = voicing.type == ChordType.major
        ? AppTheme.majorCol
        : voicing.type == ChordType.minor
        ? AppTheme.minorCol
        : AppTheme.dimCol;

    // Nut
    if (startFret == 0) {
      canvas.drawLine(
        Offset(x0, y0),
        Offset(x0 + strW * (numStrings - 1), y0),
        nutPaint,
      );
    } else {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${startFret + 1}',
          style: const TextStyle(color: AppTheme.textSecond, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x0 - 14, y0 + 2));
    }

    // Fret lines
    for (var f = 0; f <= numFrets; f++) {
      final fy = y0 + 2 + f * fretH;
      canvas.drawLine(
        Offset(x0, fy),
        Offset(x0 + strW * (numStrings - 1), fy),
        fretPaint,
      );
    }

    // Strings
    for (var s = 0; s < numStrings; s++) {
      final sx = x0 + s * strW;
      canvas.drawLine(
        Offset(sx, y0 + 2),
        Offset(sx, y0 + 2 + numFrets * fretH),
        stringPaint,
      );
    }

    // Barre bar
    if (barreAt != null) {
      final bf = barreAt - startFret;
      final by = y0 + 2 + (bf - 1) * fretH + fretH * 0.5;
      final barre = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x0 + strW * (numStrings - 1) / 2, by),
            width: strW * (numStrings - 1) + 4,
            height: 9,
          ),
          const Radius.circular(5),
        ),
        barre,
      );
    }

    // Finger dots
    for (var s = 0; s < numStrings; s++) {
      final sx = x0 + s * strW;
      final fret = frets[s];
      final finger = fingers.length > s ? fingers[s] : '';

      if (fret == -1) {
        // Muted
        final tp = TextPainter(
          text: const TextSpan(
            text: '×',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 9),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(sx - 4, y0 - 14));
      } else if (fret == 0) {
        // Open
        canvas.drawCircle(
          Offset(sx, y0 - 8),
          4,
          Paint()
            ..color = AppTheme.textSecond
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      } else {
        final rel = fret - startFret;
        final fy = y0 + 2 + (rel - 1) * fretH + fretH * 0.5;
        if (barreAt == null || fret != barreAt) {
          canvas.drawCircle(Offset(sx, fy), 5, Paint()..color = dotColor);
          if (finger.isNotEmpty && finger != 'B') {
            final tp = TextPainter(
              text: TextSpan(
                text: finger,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textDirection: TextDirection.ltr,
            )..layout();
            tp.paint(canvas, Offset(sx - tp.width / 2, fy - tp.height / 2));
          }
        }
      }
    }

    // String labels
    const sNames = ['E', 'A', 'D', 'G', 'B', 'e'];
    for (var s = 0; s < numStrings; s++) {
      final tp = TextPainter(
        text: TextSpan(
          text: sNames[s],
          style: const TextStyle(color: AppTheme.textSecond, fontSize: 7),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x0 + s * strW - tp.width / 2, y0 + 2 + numFrets * fretH + 4),
      );
    }
  }

  @override
  bool shouldRepaint(_GuitarDiagramPainter old) => old.voicing != voicing;
}

// ═══════════════════════════════════════════════════════════════
//  PIANO CHORD DIAGRAM
// ═══════════════════════════════════════════════════════════════

class PianoChordDiagram extends StatelessWidget {
  final List<int> semitones; // intervals from root (e.g. [0,4,7])
  final String rootNote;
  final ChordType type;
  final double width;

  const PianoChordDiagram({
    super.key,
    required this.semitones,
    required this.rootNote,
    required this.type,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.45,
      child: CustomPaint(
        painter: _PianoPainter(semitones: semitones, type: type),
      ),
    );
  }
}

class _PianoPainter extends CustomPainter {
  final List<int> semitones;
  final ChordType type;
  _PianoPainter({required this.semitones, required this.type});

  // 13 keys: C C# D D# E F F# G G# A A# B C
  // isBlack: 0,1,0,1,0,0,1,0,1,0,1,0,0
  static const isBlack = [
    false,
    true,
    false,
    true,
    false,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    false,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final dotColor = type == ChordType.major
        ? AppTheme.majorCol
        : type == ChordType.minor
        ? AppTheme.minorCol
        : AppTheme.dimCol;

    const totalWhite = 8; // C D E F G A B C
    final keyW = size.width / totalWhite;
    final keyH = size.height;

    // Map semitone → white key x and whether it's black
    // White key indices for semitones 0..12
    const whiteIdx = [0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 5, 6, 7];

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final whiteBorder = Paint()
      ..color = AppTheme.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final blackPaint = Paint()
      ..color = const Color(0xFF1A1410)
      ..style = PaintingStyle.fill;

    // Draw white keys
    for (var i = 0; i < 8; i++) {
      final rect = Rect.fromLTWH(i * keyW, 0, keyW - 1, keyH);
      canvas.drawRect(rect, whitePaint);
      canvas.drawRect(rect, whiteBorder);
    }

    // Draw black keys
    // Black key positions (as fraction between two white keys)
    const blackPositions = {1: 0.65, 3: 1.65, 6: 3.65, 8: 4.65, 10: 5.65};
    for (final entry in blackPositions.entries) {
      final bx = entry.value * keyW;
      final rect = Rect.fromLTWH(bx, 0, keyW * 0.6, keyH * 0.62);
      canvas.drawRect(rect, blackPaint);
    }

    // Highlight active notes
    for (final semi in semitones) {
      if (semi < 0 || semi > 12) continue;
      final black = isBlack[semi];
      final dotPaint = Paint()..color = dotColor.withOpacity(0.9);

      if (!black) {
        final wi = whiteIdx[semi];
        final cx = wi * keyW + keyW / 2;
        canvas.drawCircle(Offset(cx, keyH * 0.82), keyW * 0.28, dotPaint);
      } else {
        // Black key dot
        final blackXMap = {1: 0.65, 3: 1.65, 6: 3.65, 8: 4.65, 10: 5.65};
        final bx = (blackXMap[semi] ?? 0) * keyW + keyW * 0.3;
        canvas.drawCircle(Offset(bx, keyH * 0.45), keyW * 0.22, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_PianoPainter old) => old.semitones != semitones;
}

// ═══════════════════════════════════════════════════════════════
//  DEGREE BADGE
// ═══════════════════════════════════════════════════════════════

class DegreeBadge extends StatelessWidget {
  final String numeral;
  final ChordType type;
  final bool isSelected;
  final String function;

  const DegreeBadge({
    super.key,
    required this.numeral,
    required this.type,
    this.isSelected = false,
    required this.function,
  });

  Color get _bgColor {
    if (isSelected) return AppTheme.accent;
    return type == ChordType.major
        ? AppTheme.majorCol
        : type == ChordType.minor
        ? AppTheme.minorCol
        : AppTheme.dimCol;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? AppTheme.accent : _bgColor.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            numeral,
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 16,
              color: isSelected ? AppTheme.bg : Colors.white,
              letterSpacing: 1,
            ),
          ),
          Text(
            function,
            style: TextStyle(
              fontSize: 8,
              color: isSelected ? AppTheme.bg.withOpacity(0.7) : Colors.white38,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  AUDIO PLAYER PLACEHOLDER
// ═══════════════════════════════════════════════════════════════

class AudioPlayerWidget extends StatelessWidget {
  final String label;
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioPlayerWidget({
    super.key,
    required this.label,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                key: ValueKey(isPlaying),
                color: AppTheme.accent,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  'Audio Demo',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Fake waveform
            Row(
              children: List.generate(
                12,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  width: 3,
                  height:
                      (i % 3 == 0
                              ? 16
                              : i % 2 == 0
                              ? 10
                              : 20)
                          .toDouble(),
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? AppTheme.accent.withOpacity(0.4 + (i % 3) * 0.2)
                        : AppTheme.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DIFFICULTY CHIP
// ═══════════════════════════════════════════════════════════════

class DifficultyChip extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyChip({
    super.key,
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  static const Map<Difficulty, String> labels = {
    Difficulty.beginner: 'Beginner',
    Difficulty.intermediate: 'Intermediate',
    Difficulty.advanced: 'Advanced',
    Difficulty.professional: 'Pro',
  };
  static const Map<Difficulty, Color> colors = {
    Difficulty.beginner: AppTheme.accentGreen,
    Difficulty.intermediate: AppTheme.accentBlue,
    Difficulty.advanced: AppTheme.accent,
    Difficulty.professional: AppTheme.accentRed,
  };

  @override
  Widget build(BuildContext context) {
    final color = colors[difficulty]!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : AppTheme.cardBorder),
        ),
        child: Text(
          labels[difficulty]!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? color : AppTheme.textSecond,
          ),
        ),
      ),
    );
  }
}
