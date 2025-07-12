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
  late CircleComponent baseCircle;

  @override
  Future<void> onLoad() async {
    // موقعیت مرکزی
    centerPosition = Vector2(size.x / 2, size.y / 3);

    // نیم‌دایره اصلی (دایره کامل با پوشش ظاهری نصفه)
    baseCircle = CircleComponent(
      radius: 50,
      position: centerPosition,
      anchor: Anchor.center,
      paint: Paint()..color = Colors.red,
    );

    add(baseCircle);

    // ساخت گزینه‌ها
    final options = [
      false, // نیم‌دایره مشابه (غلط)
      false, // 1/4 دایره (غلط)
      false, // دایره کامل (غلط)
      true,  // نیم‌دایره قرینه (درست)
    ];

    for (int i = 0; i < options.length; i++) {
      final option = DraggableOption(
        isCorrect: options[i],
        paint: Paint()..color = Colors.orange,
        startPosition: Vector2(80 + i * 90, size.y - 100),
        targetPosition: centerPosition,
      );
      add(option);
    }
  }
}

class DraggableOption extends CircleComponent
    with DragCallbacks, HasGameRef<SymmetryGame> {
  final bool isCorrect;
  final Vector2 startPosition;
  final Vector2 targetPosition;

  late Vector2 dragDelta;

  DraggableOption({
    required this.isCorrect,
    required Paint paint,
    required this.startPosition,
    required this.targetPosition,
  }) : super(
    radius: 30,
    position: startPosition.clone(),
    anchor: Anchor.center,
    paint: paint,
  );

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onDragStart(DragStartEvent event) {
    dragDelta = event.localPosition;
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
        print("✅ جواب درست بود!");
      } else {
        position = startPosition.clone();
        print("❌ گزینه اشتباه بود!");
      }
    } else {
      position = startPosition.clone();
    }
  }
}
