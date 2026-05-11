// lib/providers/app_provider.dart
import 'package:flutter/material.dart';
import '../models/music_model.dart';
import '../data/music_data.dart';

class AppProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────
  Instrument _selectedInstrument = Instrument.guitar;
  MusicKey _selectedKey = allKeys[0]; // C Major
  int _selectedDegreeIndex = -1; // which chord card is highlighted
  Difficulty _filterDifficulty = Difficulty.beginner;
  bool _audioPlaying = false;
  String? _currentAudioId;
  int _completedLessons = 1;

  // ── Getters ───────────────────────────────────────────────────
  Instrument get selectedInstrument => _selectedInstrument;
  MusicKey get selectedKey => _selectedKey;
  int get selectedDegreeIndex => _selectedDegreeIndex;
  Difficulty get filterDifficulty => _filterDifficulty;
  bool get audioPlaying => _audioPlaying;
  String? get currentAudioId => _currentAudioId;
  int get completedLessons => _completedLessons;

  List<Lesson> get filteredLessons => allLessons
      .where(
        (l) =>
            l.instrument == _selectedInstrument &&
            l.difficulty == _filterDifficulty,
      )
      .toList();

  double get overallProgress => _completedLessons / allLessons.length;

  // ── Actions ───────────────────────────────────────────────────
  void selectInstrument(Instrument i) {
    _selectedInstrument = i;
    notifyListeners();
  }

  void selectKey(MusicKey k) {
    _selectedKey = k;
    _selectedDegreeIndex = -1;
    notifyListeners();
  }

  void selectDegree(int idx) {
    _selectedDegreeIndex = _selectedDegreeIndex == idx ? -1 : idx;
    notifyListeners();
  }

  void setFilterDifficulty(Difficulty d) {
    _filterDifficulty = d;
    notifyListeners();
  }

  void toggleAudio(String id) {
    if (_currentAudioId == id && _audioPlaying) {
      _audioPlaying = false;
      _currentAudioId = null;
    } else {
      _audioPlaying = true;
      _currentAudioId = id;
    }
    notifyListeners();
    // TODO: integrate audioplayers package here
  }

  void stopAudio() {
    _audioPlaying = false;
    _currentAudioId = null;
    notifyListeners();
  }

  GuitarVoicing? getVoicingForChord(String chordName) {
    final key = chordNameToVoicingKey[chordName];
    if (key == null) return null;
    return guitarVoicings[key];
  }
}
