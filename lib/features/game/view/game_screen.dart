import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:war_mail_atk_def/features/game/data/mail_repository.dart';
import 'package:war_mail_atk_def/features/game/models/mail_models.dart';
import 'package:war_mail_atk_def/features/game/state/game_controller.dart';
import 'package:war_mail_atk_def/services/score_storage.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static const routeName = '/game';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>(
      create: (_) {
        final controller = GameController(
          mailRepository: const MailRepository(),
          scoreStorage: ScoreStorage(),
        );
        controller.start();
        return controller;
      },
      child: const _GameScreenView(),
    );
  }
}

class _GameScreenView extends StatelessWidget {
  const _GameScreenView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('司令室: WARMAIL'),
        actions: [
          Consumer<GameController>(
            builder: (context, controller, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  children: [
                    _ScoreBadge(
                      icon: Icons.emoji_events_outlined,
                      label: 'スコア',
                      value: controller.score.toString(),
                    ),
                    const SizedBox(width: 12),
                    _ScoreBadge(
                      icon: Icons.flash_on_outlined,
                      label: 'エネルギー',
                      value: controller.energy.toString(),
                    ),
                    const SizedBox(width: 12),
                    _ScoreBadge(
                      icon: Icons.timer_outlined,
                      label: '残り',
                      value: _formatDuration(controller.timeRemaining),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Consumer<GameController>(
            builder: (context, controller, _) {
              if (controller.phase == GamePhase.completed ||
                  controller.phase == GamePhase.failed) {
                return _ResultOverlay(controller: controller);
              }

              final mail = controller.currentMail;

              if (mail == null) {
                return const Center(child: Text('メールが届くのを待機中...'));
              }

              if (isCompact) {
                return Column(
                  children: [
                    Expanded(
                      child: _MailListPane(
                        controller: controller,
                        isCompact: isCompact,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _MailDetailPane(
                        controller: controller,
                        mail: mail,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 220,
                    child: _CategoryPane(controller: controller),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 260,
                    child: _MailListPane(
                      controller: controller,
                      isCompact: isCompact,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MailDetailPane(
                      controller: controller,
                      mail: mail,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MailListPane extends StatelessWidget {
  const _MailListPane({
    required this.controller,
    required this.isCompact,
  });

  final GameController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '検索 (差出人 / 件名 / 本文)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: controller.queue.length,
                itemBuilder: (context, index) {
                  final mail = controller.queue[index];
                  final isSelected = controller.currentMail?.id == mail.id;
                  return _MailPreviewTile(
                    mail: mail,
                    isSelected: isSelected,
                    onTap: () => controller.selectMail(index),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MailPreviewTile extends StatelessWidget {
  const _MailPreviewTile({
    required this.mail,
    required this.isSelected,
    required this.onTap,
  });

  final MailThread mail;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = mail.category == MailCategory.trusted
        ? Colors.blue
        : mail.category == MailCategory.mission
            ? Colors.teal
            : Colors.redAccent;

    return Material(
      color: isSelected ? Colors.white10 : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mail.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mail.preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                '差出人: ${mail.sender}',
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MailDetailPane extends StatelessWidget {
  const _MailDetailPane({
    required this.controller,
    required this.mail,
  });

  final GameController controller;
  final MailThread mail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mail.subject,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('差出人: ${mail.sender}'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  mail.body,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: MailAction.values.map((action) {
                final isPrimary = action == MailAction.reply;
                final color = action == MailAction.delete
                    ? Colors.redAccent
                    : isPrimary
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white24;

                return ElevatedButton.icon(
                  onPressed: () => controller.applyAction(action),
                  icon: Icon(action.icon),
                  label: Text('${action.label} (${action.shortcutLabel})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor:
                        action == MailAction.archive ? Colors.white : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPane extends StatelessWidget {
  const _CategoryPane({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '受信欄フィルタ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...MailCategory.values.map(
              (category) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    Text(category.label),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.create),
              label: const Text('作成'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final result = controller.result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result.victory ? Icons.military_tech : Icons.warning_amber_outlined,
                color: result.victory ? Colors.amber : Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                result.victory ? '任務完了！' : '作戦失敗...再編成を',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('スコア: ${result.score}'),
              Text('処理済メール: ${result.processed}件'),
              Text('経過時間: ${_formatDuration(result.elapsed)}'),
              Text('残エネルギー: ${result.energyRemaining}'),
              const SizedBox(height: 24),
              if (controller.isSavingScore) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
              ],
              Wrap(
                spacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: controller.resetAndStart,
                    child: const Text('もう一度挑戦'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('タイトルへ戻る'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(label),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
