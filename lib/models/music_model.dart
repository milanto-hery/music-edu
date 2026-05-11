import 'package:flutter/material.dart';

// lib/models/music_models.dart

enum Instrument { guitar, piano }
enum ChordType { major, minor, diminished }
enum Difficulty { beginner, intermediate, advanced, professional }

// ── Note & Scale ──────────────────────────────────────────────────────────

class MusicNote {
  final String name;       // e.g. "C", "F#"
  final int midiNumber;    // 60 = middle C
  final bool isBlackKey;   // piano display

  const MusicNote({
    required this.name,
    required this.midiNumber,
    required this.isBlackKey,
  });
}

class ScaleDegree {
  final int degree;          // 1-7
  final String romanNumeral; // I, ii, iii, IV …
  final ChordType type;
  final String chordName;    // e.g. "C", "Dm", "Bdim"
  final String function;     // Tonic, Subdominant, Dominant…

  const ScaleDegree({
    required this.degree,
    required this.romanNumeral,
    required this.type,
    required this.chordName,
    required this.function,
  });
}

class MusicKey {
  final String name;          // "C", "G", "F#"
  final String fullName;      // "C Major"
  final List<MusicNote> scale; // 8 notes (root repeated)
  final List<ScaleDegree> degrees;
  final int sharps;           // positive = sharps, negative = flats
  final String relativeMinor;
  final String description;

  const MusicKey({
    required this.name,
    required this.fullName,
    required this.scale,
    required this.degrees,
    required this.sharps,
    required this.relativeMinor,
    required this.description,
  });
}

// ── Guitar Chord Voicing ──────────────────────────────────────────────────

class GuitarVoicing {
  /// frets[0] = low E string, frets[5] = high e
  /// -1 = mute, 0 = open, N = fret number
  final List<int> frets;
  final List<String> fingers; // "1"-"4", "B"=barre, ""=none
  final int? barreAt;         // fret number for barre
  final String chordName;
  final ChordType type;

  const GuitarVoicing({
    required this.frets,
    required this.fingers,
    this.barreAt,
    required this.chordName,
    required this.type,
  });
}

// ── Piano Chord ───────────────────────────────────────────────────────────

class PianoChord {
  final String chordName;
  final ChordType type;
  final List<int> midiNotes; // relative to root (0=root,4=maj3rd…)
  final String intervals;    // "1 - 3 - 5"

  const PianoChord({
    required this.chordName,
    required this.type,
    required this.midiNotes,
    required this.intervals,
  });
}

// ── Lesson ────────────────────────────────────────────────────────────────

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final Difficulty difficulty;
  final Instrument instrument;
  final String duration;    // "10 min"
  final List<String> topics;
  final bool isLocked;
  final bool isCompleted;
  final String? audioAsset;
  final String? videoUrl;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.instrument,
    required this.duration,
    required this.topics,
    this.isLocked = false,
    this.isCompleted = false,
    this.audioAsset,
    this.videoUrl,
  });
}

// ── Musical Style ─────────────────────────────────────────────────────────

class MusicalStyle {
  final String name;
  final String description;
  final String emoji;
  final List<String> commonProgressions;
  final Difficulty difficulty;
  final Color color; // from Flutter

  const MusicalStyle({
    required this.name,
    required this.description,
    required this.emoji,
    required this.commonProgressions,
    required this.difficulty,
    required this.color,
  });
}

// end of file