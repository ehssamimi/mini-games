import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_games/bloc/gameStates/gameState.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(hp: 4, xp: 0, currentLevel: 0));

  void loseHp() {
    if (state.hp > 0) emit(state.copyWith(hp: state.hp - 1));
  }

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
