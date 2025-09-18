import 'package:flutter/material.dart';
import 'package:war_mail_atk_def/features/game/view/game_screen.dart';
import 'package:war_mail_atk_def/features/title/title_screen.dart';
import 'package:war_mail_atk_def/features/tutorial/tutorial_screen.dart';
import 'package:war_mail_atk_def/theme/app_theme.dart';

class WarMailApp extends StatelessWidget {
  const WarMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WarMail: ATK & DEF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      initialRoute: TitleScreen.routeName,
      routes: {
        TitleScreen.routeName: (_) => const TitleScreen(),
        TutorialScreen.routeName: (_) => const TutorialScreen(),
        GameScreen.routeName: (_) => const GameScreen(),
      },
    );
  }
}
