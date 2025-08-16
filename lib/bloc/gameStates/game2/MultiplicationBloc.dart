import 'package:flutter_bloc/flutter_bloc.dart';
import 'MultiplicationEvent.dart';
import 'MultiplicationState.dart';
import 'multiplication_random.dart';

class MultiplicationBloc extends Bloc<MultiplicationEvent, MultiplicationState> {
  MultiplicationBloc()
      : super(
    MultiplicationState(
      mainNumber: 6,
      currentNumber: 1,
      correctAnswer: 5,
      options: [5, 6, 7, 8],
      score: 0,
    ),
  ) {
    on<GenerateQuestion>((event, emit) {
      final mainNumber = randMain();
      final currentNumber = randCurrent();
      final correct = mainNumber * currentNumber;
      final options = shuffledOptions(correct);

      emit(state.copyWith(
        mainNumber: mainNumber,
        currentNumber: currentNumber,
        correctAnswer: correct,
        options: options,
        isCorrect: null,
      ));
    });

    on<SubmitAnswer>((event, emit) {
      final isCorrect = event.answer == state.correctAnswer;
      emit(state.copyWith(
        score: isCorrect ? state.score + 1 : state.score,
        isCorrect: isCorrect,
      ));
    });
  }
}
