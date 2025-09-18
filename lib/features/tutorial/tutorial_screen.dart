import 'package:flutter/material.dart';
import 'package:war_mail_atk_def/features/game/view/game_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  static const routeName = '/tutorial';

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WarMail 操作チュートリアル'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('戻る'),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(_currentStep == steps.length - 1 ? '完了' : '次へ'),
                      ),
                    ],
                  );
                },
                onStepContinue: () {
                  if (_currentStep < steps.length - 1) {
                    setState(() => _currentStep += 1);
                  } else {
                    Navigator.of(context).pushReplacementNamed(GameScreen.routeName);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                steps: steps,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return const [
      Step(
        title: Text('受信箱の分類'),
        content: Text('各メールには「友軍」「任務」「スパム」のタグが付いています。左のフィルタでカテゴリを確認し、対応を決めましょう。'),
        isActive: true,
      ),
      Step(
        title: Text('アクションで攻防'),
        content: Text('返信で友軍と連携、アーカイブで保留、削除で脅威を排除します。正しいアクションでスコアが上昇し、誤った判断でエネルギーが減少します。'),
        isActive: true,
      ),
      Step(
        title: Text('制限時間とリソース'),
        content: Text('時間が尽きる前に全てのメールをさばきましょう。エネルギーがゼロになると敗北です。'),
        isActive: true,
      ),
    ];
  }
}
