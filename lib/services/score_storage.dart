import 'package:shared_preferences/shared_preferences.dart';

class ScoreSnapshot {
  const ScoreSnapshot({required this.bestScore, required this.lastScore});

  final int bestScore;
  final int lastScore;
}

class ScoreStorage {
  static const _bestScoreKey = 'war_mail_best_score';
  static const _lastScoreKey = 'war_mail_last_score';

  Future<ScoreSnapshot> loadSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    return ScoreSnapshot(
      bestScore: prefs.getInt(_bestScoreKey) ?? 0,
      lastScore: prefs.getInt(_lastScoreKey) ?? 0,
    );
  }

  Future<void> storeScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final best = prefs.getInt(_bestScoreKey) ?? 0;
    await prefs.setInt(_lastScoreKey, score);
    if (score > best) {
      await prefs.setInt(_bestScoreKey, score);
    }
  }
}
