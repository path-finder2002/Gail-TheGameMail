import 'package:flutter/material.dart';
import 'package:war_mail_atk_def/features/tutorial/tutorial_screen.dart';
import 'package:war_mail_atk_def/services/score_storage.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final storage = ScoreStorage();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF111827), Color(0xFF0B1120)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'WarMail',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ATK & DEF',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'メールは魔物。敵を送信せよ。',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          const Text('1. タイトル画面でミッションを確認'),
                          const Text('2. チュートリアルで操作を体験'),
                          const Text('3. メールを捌いてスコアを稼ぐ'),
                          const SizedBox(height: 24),
                          FutureBuilder<ScoreSnapshot>(
                            future: storage.loadSnapshot(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }

                              final score = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('前回スコア: ${score.lastScore}'),
                                  Text('ベストスコア: ${score.bestScore}'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(TutorialScreen.routeName);
                    },
                    child: const Text('ゲームを開始'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
