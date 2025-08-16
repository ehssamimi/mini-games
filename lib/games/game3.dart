import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_games/bloc/gameStates/gameCubit.dart';
import 'package:mini_games/bloc/gameStates/gameState.dart';
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
     required this.onLoseHp,
    required this.onWin,
    required this.onNextLevel,
  }) : super() {}

  final List<String> Options;
  final String CenterImage;
  final StickSide side;
  final int correctIndex;

  final void Function()? onNextLevel;
  final VoidCallback? onLoseHp;
  final VoidCallback? onWin;
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
    onWin!();

    if (onNextLevel != null) {
      onNextLevel!();
    }
  }
  void loseHearth() {
    onLoseHp!();
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

class Game3Page extends StatefulWidget {
  Game3Page({super.key});

  @override
  State<Game3Page> createState() => _Game3PageState();
}

class _Game3PageState extends State<Game3Page> {

  int currentLevelIndex = 0;
  final List<GameLevel> allGame3Levels = [
    GameLevel(
      options: ['1.png', '2.png', '3.png', '4.png'],
      side: StickSide.right,
      centerImage: '1.png',
      correctIndex: 0,
    ),
    GameLevel(
      options: ['5.png', '6.png', '7.png', '8.png'],
      side: StickSide.right,
      centerImage: '6.png',
      correctIndex: 1,
    ),
    GameLevel(
      options: ['9.png', '10.png', '11.png', '12.png'],
      side: StickSide.right,
      centerImage: '10.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['13.png', '14.png', '15.png', '16.png'],
      side: StickSide.right,
      centerImage: '14.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['17.png', '18.png', '19.png', '20.png'],
      side: StickSide.right,
      centerImage: '18.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['21.png', '22.png', '23.png', '24.png'],
      side: StickSide.right,
      centerImage: '22.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['25.png', '26.png', '27.png', '28.png'],
      side: StickSide.right,
      centerImage: '26.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['29.png', '30.png', '31.png', '32.png'],
      side: StickSide.right,
      centerImage: '30.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['33.png', '34.png', '35.png', '36.png'],
      side: StickSide.right,
      centerImage: '34.png',
      correctIndex: 1,
    ),    GameLevel(
      options: ['37.png', '38.png', '39.png', '40.png'],
      side: StickSide.right,
      centerImage: '38.png',
      correctIndex: 1,
    ),
   ];


  void nextLevel() {
    setState(() {
      if (currentLevelIndex < allGame3Levels.length - 1) {
        currentLevelIndex++;
      } else {
        // بازی تموم شده یا به مرحله اول برو
        currentLevelIndex = 0;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final level = allGame3Levels[currentLevelIndex];

    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) => previous.hp != current.hp,
      listener: (context, state) {
        if (state.hp == 0) {
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'بازی تموم شد!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text('شما همه جان‌های خود را از دست دادید.'),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                          ..pop()
                          ..pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      icon: Icon(Icons.home),
                      label: Text('بازگشت به صفحه اصلی'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: BlocBuilder<GameCubit, GameState>(
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // XP سمت چپ
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('${state.xp} XP'),
                  ],
                ),
                // مرحله وسط
                Text('مرحله ${currentLevelIndex +1}'),
                // جان‌ها سمت راست
                Row(
                  children: List.generate(4, (index) {
                    return Icon(
                      Icons.favorite,
                      color: index < state.hp ? Colors.red : Colors.grey,
                    );
                  }),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: GameWidget(
          game: game3(
            Options: level.options,
            side: level.side,
            CenterImage: level.centerImage,
            correctIndex: level.correctIndex,
            onNextLevel: nextLevel,
            onLoseHp: () => context.read<GameCubit>().loseHp(),
            onWin: () => context.read<GameCubit>().winLevel(),
          ),
          overlayBuilderMap: {
            'alert': (context, game) => AlertOverlay(game: game as game3),
          },
        ),
      ),
    );
  }

}


class GameLevel {
  final List<String> options;
  final StickSide side;
  final String centerImage;
  final int correctIndex;

  GameLevel({
    required this.options,
    required this.side,
    required this.centerImage,
    required this.correctIndex,
  });
}
