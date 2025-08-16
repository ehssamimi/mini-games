import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';




import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MultiplicationGamePage extends StatelessWidget {
  const MultiplicationGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(game: MultiplicationGame()),
    );
  }
}

class MultiplicationGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final start = Vector2(size.x / 2, size.y - 100);
    add(DraggableChain(
      startPosition: start,
      count: 4,
      radius: 20,
      color: Colors.blue,
      gap: 12,
    ));
  }
}

class DraggableChain extends Component with HasGameRef<MultiplicationGame> {
  final Vector2 startPosition;
  final int count;
  final double radius;
  final Color color;
  final double gap;
  final List<PositionComponent> dots = [];

  DraggableChain({
    required this.startPosition,
    required this.count,
    required this.radius,
    required this.color,
    required this.gap,
  });

  @override
  Future<void> onLoad() async {
    final leader = DraggableHead(
      radius: radius,
      color: color,
      position: startPosition,
    );
    add(leader);
    dots.add(leader);

    for (int i = 1; i < count; i++) {
      final dot = CircleComponent(
        radius: radius,
        anchor: Anchor.center,
        position: startPosition + Vector2(0, i * (radius * 2 + gap)),
        paint: Paint()..color = color,
      );
      add(dot);
      dots.add(dot);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    const stiffness = 0.2;

    for (int i = 1; i < dots.length; i++) {
      final leader = dots[i - 1];
      final follower = dots[i];

      final desired = leader.position -
          (leader.position - follower.position).normalized() *
              (radius * 2 + gap);
      final offset = desired - follower.position;
      follower.position += offset * stiffness;
    }
  }
}

class DraggableHead extends PositionComponent with DragCallbacks {
  final double radius;
  final Color color;
  late final CircleComponent circle;

  DraggableHead({
    required this.radius,
    required this.color,
    required Vector2 position,
  }) {
    this.position = position;
    anchor = Anchor.center;
    size = Vector2.all(radius * 2);
  }

  @override
  Future<void> onLoad() async {
    circle = CircleComponent(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()..color = color,
      position: size / 2,
    );
    add(circle);
    add(RectangleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}

