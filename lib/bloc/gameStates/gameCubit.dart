import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_games/bloc/gameStates/gameState.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(hp: 4, xp: 0, currentLevel: 0));

  void loseHp() {
    if (state.hp > 1) {
      emit(state.copyWith(hp: state.hp - 1));
    } else {
      // HP میشه صفر
      emit(state.copyWith(hp: 0));
      // می‌تونی یک استیت خاص برای Game Over داشته باشی (اختیاری)
    }  }

  void winLevel() {
    emit(
      state.copyWith(
        xp: state.xp + 1,
        currentLevel: state.currentLevel + 30,
        // hp: 4, // مرحله جدید، hp ریست میشه (می‌تونی تغییر بدی)
      ),
    );
  }

  void restart() {
    emit(GameState(hp: 4, xp: 0, currentLevel: 0));
  }
}
