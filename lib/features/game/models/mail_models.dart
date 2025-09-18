import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MailCategory {
  trusted('友軍'),
  mission('課業'),
  spam('スパム');

  const MailCategory(this.label);
  final String label;
}

enum MailAction {
  reply('返信', Icons.reply, LogicalKeyboardKey.keyR),
  archive('アーカイブ', Icons.archive, LogicalKeyboardKey.keyE),
  delete('削除', Icons.delete, LogicalKeyboardKey.numberSign);

  const MailAction(this.label, this.icon, this.shortcut);

  final String label;
  final IconData icon;
  final LogicalKeyboardKey shortcut;

  String get shortcutLabel {
    if (shortcut == LogicalKeyboardKey.numberSign) {
      return '#';
    }
    if (shortcut.keyLabel.isNotEmpty) {
      return shortcut.keyLabel.toUpperCase();
    }
    return shortcut.debugName ?? '';
  }
}

class MailThread {
  MailThread({
    required this.id,
    required this.subject,
    required this.sender,
    required this.preview,
    required this.body,
    required this.category,
    required this.recommendedAction,
  });

  final String id;
  final String subject;
  final String sender;
  final String preview;
  final String body;
  final MailCategory category;
  final MailAction recommendedAction;
}
