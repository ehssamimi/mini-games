import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mini_games/components/game2/bird.dart';

class MyFlameGame2 extends FlameGame with TapDetector{

  late Bird bird;


  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    bird.flap();
  }
}

class Game2Page extends StatelessWidget {
  const Game2Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('game2')),
      body: GameWidget(game: MyFlameGame2()),
    );
  }
}
