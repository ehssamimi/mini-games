import 'package:flutter/material.dart';
import 'package:mini_games/games/game3.dart';

class AlertOverlay extends StatelessWidget {
  final game3 game;
  const AlertOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // تعیین رنگ و متن دکمه براساس جواب
    final isCorrect = game.isLastAnswerCorrect ?? false;
    final bgColor = isCorrect ? Colors.green[400] : Colors.red[400];
    final buttonText = isCorrect ? 'مرحله بعد' : 'تلاش دوباره';

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: Colors.white),
                  const SizedBox(width: 12),
                  Flexible(child: Text(
                    game.activeAlertText ?? '',
                    style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                  )),
                  const SizedBox(width: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: bgColor, // برای متن
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      game.overlays.remove('alert');
                      game.activeAlertText = null;
                      if (game.onAlertButtonPressed != null) {
                        game.onAlertButtonPressed!();
                      }
                    },
                    child: Text(buttonText, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bgColor
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

