import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:war_mail_atk_def/features/game/data/mail_repository.dart';
import 'package:war_mail_atk_def/features/game/models/mail_models.dart';
import 'package:war_mail_atk_def/services/score_storage.dart';

const _startingTime = Duration(seconds: 45);
const _startingEnergy = 3;
const _correctScore = 120;
const _comboBonus = 25;
const _penaltyScore = 60;
const _timePenaltyPerAction = Duration(seconds: 5);

enum GamePhase { ready, playing, completed, failed }

class GameResult {
  const GameResult({
    required this.score,
    required this.victory,
    required this.processed,
    required this.energyRemaining,
    required this.elapsed,
  });

  final int score;
  final bool victory;
  final int processed;
  final int energyRemaining;
  final Duration elapsed;
}

class GameController extends ChangeNotifier {
  GameController({
    required MailRepository mailRepository,
    required ScoreStorage scoreStorage,
  })  : _mailRepository = mailRepository,
        _scoreStorage = scoreStorage {
    _reset();
  }

  final MailRepository _mailRepository;
  final ScoreStorage _scoreStorage;

  late List<MailThread> _queue;
  int _selectedIndex = 0;
  int _score = 0;
  int _energy = _startingEnergy;
  int _combo = 0;
  int _processed = 0;
  Duration _timeRemaining = _startingTime;
  GamePhase _phase = GamePhase.ready;
  GameResult? _result;
  bool _savingScore = false;

  List<MailThread> get queue => List.unmodifiable(_queue);
  MailThread? get currentMail =>
      _queue.isEmpty ? null : _queue[_selectedIndex.clamp(0, _queue.length - 1)];
  int get score => _score;
  int get energy => _energy;
  int get combo => _combo;
  int get processed => _processed;
  Duration get timeRemaining => _timeRemaining;
  GamePhase get phase => _phase;
  GameResult? get result => _result;
  bool get isSavingScore => _savingScore;

  void start() {
    if (_phase == GamePhase.playing) {
      return;
    }
    if (_phase == GamePhase.completed || _phase == GamePhase.failed) {
      _reset();
    }
    _phase = GamePhase.playing;
    notifyListeners();
  }

  void _reset() {
    _queue = List<MailThread>.from(_mailRepository.inbox());
    _selectedIndex = 0;
    _score = 0;
    _energy = _startingEnergy;
    _combo = 0;
    _processed = 0;
    _timeRemaining = _startingTime;
    _phase = GamePhase.ready;
    _result = null;
    _savingScore = false;
  }

  void selectMail(int index) {
    if (_phase != GamePhase.playing) {
      return;
    }
    if (index < 0 || index >= _queue.length) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> applyAction(MailAction action) async {
    if (_phase != GamePhase.playing || currentMail == null) {
      return;
    }

    _advanceClock();

    final mail = currentMail!;
    final wasCorrect = mail.recommendedAction == action;
    if (wasCorrect) {
      _combo += 1;
      _score += _correctScore + (_combo - 1) * _comboBonus;
    } else {
      _combo = 0;
      _energy -= 1;
      _score = (_score - _penaltyScore).clamp(0, 99999);
    }

    _queue.removeAt(_selectedIndex);
    _processed += 1;

    if (_queue.isEmpty) {
      _completeGame(victory: true);
      await _persistScore();
      return;
    }

    if (_selectedIndex >= _queue.length) {
      _selectedIndex = _queue.length - 1;
    }

    if (_energy <= 0 || _timeRemaining <= Duration.zero) {
      _completeGame(victory: false);
      await _persistScore();
    }

    notifyListeners();
  }

  void _advanceClock() {
    _timeRemaining -= _timePenaltyPerAction;
    if (_timeRemaining.isNegative) {
      _timeRemaining = Duration.zero;
    }
  }

  void _completeGame({required bool victory}) {
    final elapsed = _startingTime - _timeRemaining;
    _phase = victory ? GamePhase.completed : GamePhase.failed;
    _result = GameResult(
      score: _score,
      victory: victory,
      processed: _processed,
      energyRemaining: _energy.clamp(0, _startingEnergy),
      elapsed: elapsed.isNegative ? Duration.zero : elapsed,
    );
  }

  Future<void> _persistScore() async {
    if (_savingScore) {
      return;
    }
    _savingScore = true;
    notifyListeners();
    try {
      await _scoreStorage.storeScore(_score);
    } finally {
      _savingScore = false;
      notifyListeners();
    }
  }

  void resetAndStart() {
    _reset();
    _phase = GamePhase.playing;
    notifyListeners();
  }
}
