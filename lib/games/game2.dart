import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyFlameGame2 extends FlameGame {
  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(50, 50, 100, 100), Paint()..color = Colors.green);
  }
  @override
  void update(double dt) {}
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
