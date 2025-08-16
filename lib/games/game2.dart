import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_games/bloc/gameStates/game2/MultiplicationBloc.dart';
import 'package:mini_games/bloc/gameStates/game2/MultiplicationEvent.dart';
import 'package:mini_games/bloc/gameStates/game2/MultiplicationState.dart';


class MultiplicationGamePage extends StatefulWidget {
  const MultiplicationGamePage({super.key});

  @override
  State<MultiplicationGamePage> createState() => _MultiplicationGamePageState();
}

class _MultiplicationGamePageState extends State<MultiplicationGamePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }


  @override
  void dispose() {
    // بعد از خروج از صفحه، حالت به همه جهت‌ها برمی‌گردد (در صورت نیاز)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: MultiplicationGame( bloc: context.read<MultiplicationBloc>() ),
      ),
      // اینجا هم Flame دسترسی به Bloc داره!
    );
  }
}

class MultiplicationGame extends FlameGame {
  final MultiplicationBloc bloc;
  int currentStep = 1; // شروع از 1
  int maxStep = 10;
  List<AnswerBox>? boxes; // برای رجوع بعدا

  MultiplicationGame({required this.bloc});
  // لیست رنگ‌ها برای هر مرحله
  final List<Color> colorChoices = [
    Colors.red, Colors.green, Colors.grey, Colors.blue, Colors.purple ,Colors.indigo
  ];

  void nextStep() {

    if (currentStep > maxStep) {
      // بازی تمام
      return;
    }
    final mainNumber = bloc.state.mainNumber;
    final generatedBoxes = generateStepBoxes(
      mainNumber: mainNumber,
      currentStep: currentStep,
      numBoxes: 4,
      colors: colorChoices,
    );
    // پاک‌کردن باکس‌های قبلی
    boxes?.forEach(remove);
    boxes = [];

    final totalWidth = 4 * 100.0 + 3 * 16.0;
    final startX = (size.x - totalWidth) / 2;
    double gap = 16.0; // فاصله دلخواه خارجی
    int numBoxes = 4;
    double totalGap = (numBoxes - 1) * gap;
    // double availableWidth = game.size.x - 2 * gap; // فاصله لبه بیرون
    // double boxWidth = (availableWidth - totalGap) / numBoxes;
    final boxHeight = 60.0;
    double rowY = 40;
    // final totalWidth = (boxWidth * numBoxes) + gap * (numBoxes-1);
    // final startX = (size.x - totalWidth) / 2;

    final rowHitbox = RectangleComponent(
      size: Vector2(totalWidth, boxHeight),
      position: Vector2(startX, rowY),
      paint: Paint()..color = Colors.transparent,
    );
    add(rowHitbox);

    for (int i = 0; i < 4; i++) {
      final b = AnswerBox(
        color: generatedBoxes[i].color,
        value: generatedBoxes[i].value,
        width: 100,
        height: 60,
        position: Vector2(startX + i * (100 + 16), 40),
        speed: 160,
      );
      boxes!.add(b);
      add(b);
    }
  }


  @override
  Future<void> onLoad() async {
     final start = Vector2(size.x / 2, size.y - 200);
    add(DraggableChain(
      startPosition: start,
      count: 4,
      radius: 20,
      color: Colors.blue,
      gap: 12,
    ));
     nextStep();


    // مشخصات و موقعیت باکس‌ها
    // final numBoxes = 4;
    // final boxWidth = 100.0;
    // final boxHeight = 60.0;
    // final gap = 16.0;
    // final colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue];
    //
    // // شروع x طوری باشه که باکس‌ها وسط چین شن
    // final totalWidth = numBoxes * boxWidth + (numBoxes - 1) * gap;
    // final startX = (size.x - totalWidth) / 2;
    //
    // for (int i = 0; i < numBoxes; i++) {
    //   add(AnswerBox(
    //     color: colors[i],
    //     label: 'گزینه ${i + 1}',
    //     width: boxWidth,
    //     height: boxHeight,
    //     position: Vector2(startX + i * (boxWidth + gap), 40),
    //     // همه با یک y شروع میشن
    //     speed: 160, // هر باکس سرعت خاصی میتونه داشته باشه!
    //   ));
    // }
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

  late DraggableHead leader;

  @override
  Future<void> onLoad() async {
    leader = DraggableHead(
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
        paint: Paint()
          ..color = color,
      );
      add(dot);
      dots.add(dot);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    const stiffness = 0.13;

    for (int i = 1; i < dots.length; i++) {
      final leader = dots[i - 1];
      final follower = dots[i];

      final desired = leader.position + Vector2(0, radius * 2 + gap);
      final offset = desired - follower.position;
      follower.position += offset * stiffness * (dt * 60); // <-- اینو اضافه کن
    }
  }


}

class DraggableHead extends PositionComponent
    with DragCallbacks, HasGameReference<MultiplicationGame> {
  late MultiplicationBloc bloc;
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

  late int number = 0;

  @override
  Future<void> onLoad() async {
    bloc =game.bloc;
    final text = TextComponent(
      text: getHeader(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(size.x / 2, -10);
    add(text);

    circle = CircleComponent(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = color,
      position: size / 2,
    );
    add(circle);
    add(RectangleHitbox());
  }

  Rect toRect() =>
      Rect.fromCenter(
        center: position.toOffset(),
        width: size.x,
        height: size.y,
      );

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
    final headRect = toRect();
    final allBoxes = game.children.whereType<AnswerBox>();
    bool hit = false;

    for (final box in allBoxes) {
      if (headRect.overlaps(box.toRect())) { // اینجا overlap چک می‌کنه
        hit = true;
        break;
      }
    }
    if (hit) {
      // همه باکس‌ها یکجا ریست شوند
      for (final box in allBoxes) {
        box.resetToTop();

      }
      game.currentStep++;
      game.nextStep();
    }
  }

  String getHeader() {
    final state = bloc.state;

    number++;
    return '${state.mainNumber}×${number}';
    // return '3×${number}';
  }

}

class AnswerBox extends PositionComponent with HasGameRef, CollisionCallbacks {
  final Color color;
  final int value;

  final double width;
  final double height;
  final double speed; // سرعت حرکت پایین

  AnswerBox({
    required this.color,
    required this.value,

    required this.width,
    required this.height,
    required Vector2 position,
    this.speed = 100, // به دلخواه (پیکسل بر ثانیه)
  }) {
    this.position = position;
    this.size = Vector2(width, height);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleComponent(
      size: size,
      paint: Paint()
        ..color = color,
      anchor: Anchor.topLeft,
    ));
    add(TextComponent(
      text: '$value',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      position: size / 2,
      anchor: Anchor.center,
    ));
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    // اگر باکس از پایین خارج شد، دوباره بیار بالا (Loop بشه)
    if (position.y > gameRef.size.y) {
      position.y = -height;
    }
  }

  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }

  void resetToTop() {
    position.y = -size.y; // میاد بالای صفحه (کاملاً بیرون از صفحه)
    // اگر خواستی میتوانی X یا چیزهای دیگر رو هم رندوم کنی
  }

}

class AnswerBoxData {
  final int value;
  final Color color;
  AnswerBoxData(this.value, this.color);
}

List<AnswerBoxData> generateStepBoxes({
  required int mainNumber,
  required int currentStep,
  required int numBoxes,
  required List<Color> colors,
}) {
  final random = Random();

  // جواب صحیح
  final correct = mainNumber * currentStep;

  // لیست جواب‌ها
  final values = <int>[correct];
  while (values.length < numBoxes) {
    int rand = (1 + random.nextInt(10)) * mainNumber;
    if (!values.contains(rand)) {
      values.add(rand);
    }
  }

  // شافل کنیم
  values.shuffle();

  // هر کدام یه رنگ متفاوت (یا شافل)
  final shuffledColors = List<Color>.from(colors)..shuffle();

  // لیست جواب و رنگ
  return List.generate(numBoxes, (i) => AnswerBoxData(values[i], shuffledColors[i]));
}




