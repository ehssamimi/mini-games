import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_games/components/game3/centerTarget.dart';
import 'package:mini_games/games/game3.dart';
import 'package:flame/effects.dart';


// این کامپوننت یک عکس (سیب) رو نمایش میده و قابل درگ کردنه
class DraggableApple extends SpriteComponent with HasGameReference<game3>, DragCallbacks {
  DraggableApple({
    required this.index,
    required this.total,
    required this.spritePath,
    required this.correctIndex,
    required this.side,
    Vector2? size,
  }) : super(size: size ?? Vector2(80, 80)) {
    // اندازه apple به صورت پیش‌فرض 80x80 ولی اگر خواستی میتونی override کنی
  }

  final int index;
  final int total;
  final String spritePath;
  final int correctIndex;
  final StickSide side; // یا top/left/bottom(دینامیک یا بر حسب نیاز)


  late Vector2 homePosition; // جای اصلی سیب


  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spritePath);
    //از مختضات مرکزی جابجا می کنه
    anchor = Anchor.center;

    // حالا چیدن داینامیک:
    final double padding = 20; // فاصله بین سیب‌ها
    final double totalWidth = (size.x * total) + (padding * (total - 1));
    final double startX = (game.size.x - totalWidth) / 2 + size.x / 2;

    homePosition = Vector2(
      startX + index * (size.x + padding),
      game.size.y - size.y, // میاد پایین صفحه
    );
    position = homePosition.clone();


  }
  @override
  void onDragStart(DragStartEvent event) {
    // condition no drag
    if (!game.dragEnabled) return;

    priority = 10;
    removeAll(children.whereType<Effect>().toList()); // همه افکت‌ها رو پاک کن

    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // condition no drag
    if (!game.dragEnabled) return;

    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // condition no drag
    if (!game.dragEnabled) return;

    final target = game.findByKeyName<CenterTarget>('target');

    if (target != null && target.toRect().overlaps(toRect())) {
      if (index == correctIndex) {
        // انتخاب جهت چسباندن (مثلاً سمت راست)
        const double margin = 0; // میزان فاصله از هدف

        final stickPosition = game.getStickPositionHitbox(
          target,
          this, // چون در داخل apple هستی، همون this یعنی apple جاری
          side,
          margin,
        );

        add(MoveEffect.to(
          stickPosition,
          EffectController(duration: 0.3, curve: Curves.easeOut),
        ));
        game.disableDrag();


        game.showAlert(
          message: 'آفرین! پاسخ درست بود!',
          isCorrect: true,
          onButtonPressed: () {
            game.enableDrag();
            // برو مرحله بعد
            game.nextLevel();
          },
        );

      } else {
        _returnToOrigin();
        game.disableDrag();

        game.showAlert(
          message: 'غلط بود! دوباره امتحان کن.',
          isCorrect: false,
          onButtonPressed: () {
            game.enableDrag();

            // ریست یا ری‌استارت مرحله جاری مثلاً:
            game.loseHearth();
          },
        );      }
    } else {
      _returnToOrigin();
    }
    super.onDragEnd(event);
  }



  void _returnToOrigin() {
    // اگه خیلی کم جابجا شده بود، نیاز نیست
    if ((position - homePosition).length2 < 1) return;
    // انیمیشن حرکت نرم با MoveEffect
    add(MoveEffect.to(
      homePosition.clone(),
      EffectController(
        duration: 0.3, // مدت زمان بازگشت
        curve: Curves.easeOut,
      ),
    ));
  }


}
