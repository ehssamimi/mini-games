
import 'package:flame/components.dart';
 import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_games/games/game3.dart';


class CenterTarget extends SpriteComponent with HasGameReference<game3> {
  CenterTarget({
    Vector2? position,
    Vector2? size,
    ComponentKey? key,
    required this.spritePath,
  }) : super(position: position, size: size, key: key);
  final String spritePath;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spritePath);
    anchor = Anchor.center;

  }

  // @override
  // void render(Canvas canvas) {
  //   // بک‌گراند رنگی (زیر تصویر)
  //   canvas.drawRect(
  //     Rect.fromCenter(
  //       center: Offset(size.x / 2, size.y / 2),
  //       width: size.x,
  //       height: size.y,
  //     ),
  //     Paint()..color = const Color(0x33FF0000), // قرمز شفاف
  //   );
  //   // تصویر والد (Sprite)
  //   super.render(canvas);
  // }
}
