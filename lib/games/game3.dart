import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mini_games/components/game2/bird.dart';
import 'package:mini_games/components/game3/AlertOverlay.dart';
import 'package:mini_games/components/game3/centerTarget.dart';
import 'package:mini_games/components/game3/ecahItem.dart';


enum StickSide {
  right,
  left,
  top,
  bottom,
}
class game3 extends FlameGame with HasGameReference{
  game3({
    required this.Options,
    required this.CenterImage,
    required this.side,
    required this.correctIndex,
  }) : super() {}

  final List<String> Options;
  final String CenterImage;
  final StickSide side;
  final int correctIndex;


// برای نمایش پیام موفقیت و شکست
  bool? isLastAnswerCorrect;
  VoidCallback? onAlertButtonPressed;
  String? activeAlertText;


  void showAlert({
    required String message,
    required bool isCorrect, // صحیح یا غلط بودن جواب
    required VoidCallback onButtonPressed, // اکشن بعدی
  }) {
    activeAlertText = message;
    isLastAnswerCorrect = isCorrect;
    onAlertButtonPressed = onButtonPressed;
    overlays.add('alert');
  }
  void nextLevel() {
    // اینجا منطقش رو می‌نویسی
  }
  void restartLevel() {
    // اینجا هم ریست
  }


  bool dragEnabled = true; // یا به صورت ValueNotifier اگر خواستی با UI bind شه

  void disableDrag() => dragEnabled = false;
  void enableDrag() => dragEnabled = true;


  @override
  Future<void> onLoad() async {
    final target = CenterTarget(
      position: Vector2(game.size.x/2, game.size.y/2),
      size: Vector2(120, 120),
      key: ComponentKey.named('target'), spritePath: CenterImage,
    );
    add(target);


    final total = Options.length;
    for (int i = 0; i < total; i++) {
      add(DraggableApple(
        index: i,
        total: total,
        spritePath: Options[i],
          correctIndex:correctIndex,
          side: side
      ));
    }
  }


  Vector2 getStickPositionHitbox(PositionComponent target, PositionComponent obj,
      StickSide side, double margin) {
    // فرضیه: anchor هر دو روی center هست
    final tPos = target.position;
    final tSize = target.size;
    final oSize = obj.size;

    double x = tPos.x;
    double y = tPos.y;
    switch (side) {
      case StickSide.right:
        x += (tSize.x / 2) + (oSize.x / 2) + margin;
        break;
      case StickSide.left:
        x -= (tSize.x / 2) + (oSize.x / 2) + margin;
        break;
      case StickSide.top:
        y -= (tSize.y / 2) + (oSize.y / 2) + margin;
        break;
      case StickSide.bottom:
        y += (tSize.y / 2) + (oSize.y / 2) + margin;
        break;
    }
    return Vector2(x, y);
  }

}

class Game3Page extends StatelessWidget {



    Game3Page({super.key});

  final List<String> Options = [
    '2.png',
    '4.png',
    '6.png',
    '8.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('game2')),
      body: GameWidget(game: game3(
          Options:Options, side: StickSide.right, CenterImage: Options[3],correctIndex:3),
        overlayBuilderMap: {
        'alert': (context, game) => AlertOverlay(game: game as game3), // اسم کلاس بازی!
      },),
    );
  }
}
