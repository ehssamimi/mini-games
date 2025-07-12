import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Game1Page extends StatelessWidget {
  const Game1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بازی تقارن سیب')),
      body: GameWidget(game: SymmetryGame()),
    );
  }
}

class SymmetryGame extends FlameGame {
  late Vector2 centerPosition;

  @override
  Future<void> onLoad() async {
    // برای فعال کردن DragCallbacks
    children.register<DragCallbacks>();

    // موقعیت نیم‌دایره اصلی
    centerPosition = Vector2(size.x / 2, size.y / 3);

    // نیم‌دایره اصلی (قرینه بالا)
    final mainArc = ArcComponent(
      startAngle: -pi / 2,
      sweepAngle: pi,
      color: Colors.red,
      isCorrect: false,
      startPosition: centerPosition,
      targetPosition: centerPosition,
    );
    add(mainArc);

    // گزینه‌های پایین صفحه
    final options = [
      ArcComponent( // نیم‌دایره مشابه
        startAngle: -pi / 2,
        sweepAngle: pi,
        color: Colors.orange,
        isCorrect: false,
        startPosition: Vector2(80, size.y - 100),
        targetPosition: centerPosition,
      ),
      ArcComponent( // ربع‌دایره
        startAngle: -pi / 2,
        sweepAngle: pi / 2,
        color: Colors.green,
        isCorrect: false,
        startPosition: Vector2(160, size.y - 100),
        targetPosition: centerPosition,
      ),
      ArcComponent( // دایره کامل
        startAngle: 0,
        sweepAngle: 2 * pi,
        color: Colors.blue,
        isCorrect: false,
        startPosition: Vector2(240, size.y - 100),
        targetPosition: centerPosition,
      ),
      ArcComponent( // نیم‌دایره قرینه (جواب درست)
        startAngle: pi / 2,
        sweepAngle: pi,
        color: Colors.orange,
        isCorrect: true,
        startPosition: Vector2(320, size.y - 100),
        targetPosition: centerPosition,
      ),
    ];

    addAll(options);
  }
}

class ArcComponent extends PositionComponent
    with DragCallbacks, HasGameRef<SymmetryGame> {
  final double startAngle;
  final double sweepAngle;
  final bool isCorrect;
  final Vector2 startPosition;
  final Vector2 targetPosition;
  final Color color;

  late Paint _paint;

  ArcComponent({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    required this.isCorrect,
    required this.startPosition,
    required this.targetPosition,
  }) {
    size = Vector2.all(60);
    position = startPosition.clone();
    anchor = Anchor.center;
    priority = 10;
    _paint = Paint()..color = color;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()); // برای فعال کردن تعامل لمسی و درگ
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return toRect().contains(point.toOffset());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromCircle(
      center: Offset(size.x / 2, size.y / 2),
      radius: size.x / 2,
    );
    canvas.drawArc(rect, startAngle, sweepAngle, true, _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    final distance = position.distanceTo(targetPosition);
    if (distance < 60) {
      if (isCorrect) {
        position = targetPosition.clone() + Vector2(50, 0);
        print("✅ درست بود!");
      } else {
        position = startPosition.clone();
        print("❌ اشتباه بود!");
      }
    } else {
      position = startPosition.clone();
    }
  }
}
