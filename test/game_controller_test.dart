import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:war_mail_atk_def/features/game/data/mail_repository.dart';
import 'package:war_mail_atk_def/features/game/models/mail_models.dart';
import 'package:war_mail_atk_def/features/game/state/game_controller.dart';
import 'package:war_mail_atk_def/services/score_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GameController createController() {
    return GameController(
      mailRepository: const MailRepository(),
      scoreStorage: ScoreStorage(),
    );
  }

  test('applies positive score for correct action', () async {
    final controller = createController();
    controller.start();

    final firstMail = controller.currentMail!;
    await controller.applyAction(firstMail.recommendedAction);

    expect(controller.score, greaterThan(0));
    expect(controller.processed, 1);
  });

  test('reduces energy when incorrect action is taken', () async {
    final controller = createController();
    controller.start();

    final firstMail = controller.currentMail!;
    final wrongAction = MailAction.values
        .firstWhere((action) => action != firstMail.recommendedAction);

    final startingEnergy = controller.energy;
    await controller.applyAction(wrongAction);

    expect(controller.energy, lessThan(startingEnergy));
    expect(controller.score, equals(0));
  });
}
