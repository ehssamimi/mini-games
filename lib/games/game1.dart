import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';   // <== این خط رو اضافه کن


class SymmetryGame extends FlameGame with HasCollisionDetection {
  late TargetArcComponent target;
  late List<DraggableArcComponent> draggables;

  // State for overlays
  bool showResult = false;
  bool isWin = false;

  @override
  Color backgroundColor() => const Color(0xFFF8F8F8);

  @override
  Future<void> onLoad() async {
    // ------ ONLY THIS LINE FOR THE NEW EVENT SYSTEM ------
    children.register<DragCallbacks>();

    // مرکز (هدف)
    target = TargetArcComponent(
      startAngle: pi, // نیم‌دایره پایین
      sweepAngle: pi,
      position: size / 2,
      color: Colors.redAccent,
    );
    add(target);

    // ۴ قطعه پایین
    draggables = [];

    final positions = [
      Vector2(size.x * 0.2, size.y - 70),
      Vector2(size.x * 0.4, size.y - 70),
      Vector2(size.x * 0.6, size.y - 70),
      Vector2(size.x * 0.8, size.y - 70),
    ];
    final colors = [
      Colors.redAccent,
      Colors.green,
      Colors.blue,
      Colors.orange,
    ];
    final angles = [
      0.0,
      pi / 2,
      pi,
      3 * pi / 2,
    ];

    for (int i = 0; i < 4; i++) {
      final drag = DraggableArcComponent(
        id: i,
        startAngle: angles[i],
        sweepAngle: pi,
        color: colors[i],
        position: positions[i],
        onValidate: handleValidation,
      );
      draggables.add(drag);
      add(drag);
    }
  }

  // اعتبارسنجی تطابق Drag
  void handleValidation(DraggableArcComponent arc) {
    final target = this.target;
    final double snapDistance = 54;

    // فاصله محل قرارگیری قطعه نسبت به مرکز هدف
    final distance = (arc.position - target.position).length;

    // قرینه بودن زاویه (فرق زاویه نصف دور باشد!)
    double mirroredAngle = (arc.startAngle + pi) % (2 * pi);
    double angleDiff = ((mirroredAngle - target.startAngle) % (2 * pi)).abs();

    bool isColorSame = arc.color.value == target.color.value;
    bool isAngleMirrored = ((mirroredAngle - target.startAngle).abs() < 0.01);

    if (distance < snapDistance && isColorSame && isAngleMirrored) {
      isWin = true;
      showResult = true;

      // چسباندن دقیق قطعه به مرکز هدف و تنظیم anchor و زاویه
      arc.position = target.position.clone();
      arc.angle = target.angle;
      arc.priority = 1;
      arc.isSnapped = true; // اضافه کن flag که دوباره کشیده نشه

    } else {
      isWin = false;
      showResult = true;
      arc.resetPosition();
    }

    overlays.add('ResultOverlay');
    Future.delayed(const Duration(seconds: 2), () {
      overlays.remove('ResultOverlay');
      showResult = false;
    });
  }

}

// هدف مرکزی
class TargetArcComponent extends PositionComponent {
  final double startAngle;
  final double sweepAngle;
  final Color color;

  TargetArcComponent({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    required Vector2 position,
  }) {
    this.position = position;
    size = Vector2.all(80);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(isSolid: false)); // برای تعامل
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromCircle(
      center: Offset(size.x / 2, size.y / 2),
      radius: size.x / 2 - 5,
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }
}

// قطعه نیم‌دایره قابل درگ
class DraggableArcComponent extends PositionComponent with DragCallbacks, HasGameRef<SymmetryGame> {
  final int id;
  final double startAngle;
  final double sweepAngle;
  final Color color;
  final void Function(DraggableArcComponent) onValidate;

  late Vector2 _initialPosition;
  bool isDragging = false;
  bool isSnapped = false;



  DraggableArcComponent({
    required this.id,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    required Vector2 position,
    required this.onValidate,
  }) {
    this.position = position.clone();
    size = Vector2.all(60);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    _initialPosition = position.clone();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromCircle(
      center: Offset(size.x / 2, size.y / 2),
      radius: size.x / 2 - 4,
    );
    final paint = Paint()
      ..color = color.withOpacity(isDragging ? 0.65 : 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (isSnapped) return; // دیگه قابل کشیدن نباشه
    isDragging = true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    isDragging = false;
    final target = gameRef.target;
    final distance = (position - target.position).length;
    if (distance < 54) {
      onValidate(this);
    } else {
      resetPosition();
    }
  }

  void resetPosition() {
    position = _initialPosition.clone();
  }
}

// ======= Overlay Widget =======

Widget resultOverlay(BuildContext context, SymmetryGame game) {
  if (!game.showResult) return const SizedBox.shrink();
  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [const BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Text(
        game.isWin ? 'درست بود 👏' : 'اشتباه 😔',
        style: TextStyle(
          fontSize: 28,
          color: game.isWin ? Colors.green : Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ======= Example Usage In Your Page =======

class Game1Page extends StatelessWidget {
  const Game1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final game = SymmetryGame();
    return Scaffold(
      appBar: AppBar(title: const Text('بازی تقارن سیب')),
      body: GameWidget<SymmetryGame>(
        game: game,
        overlayBuilderMap: {
          'ResultOverlay': (ctx, game) => resultOverlay(ctx, game as SymmetryGame),
        },
      ),
    );
  }
}
