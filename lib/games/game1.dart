import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyFlameGame1 extends FlameGame {
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(100, 100), 50, Paint()..color = Colors.red);
  }
  @override
  void update(double dt) {}
}

class Game1Page extends StatelessWidget {
  const Game1Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' game 1')),
      body: GameWidget(game: MyFlameGame1()),
    );
  }
}
