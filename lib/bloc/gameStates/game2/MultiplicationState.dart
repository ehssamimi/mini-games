import 'package:equatable/equatable.dart';

class MultiplicationState extends Equatable {
  final int mainNumber;
  final int currentNumber;
  final int correctAnswer;
  final List<int> options;
  final int score;
  final bool? isCorrect;

  const MultiplicationState({
    required this.mainNumber,
    required this.currentNumber,
    required this.correctAnswer,
    required this.options,
    required this.score,
    this.isCorrect,
  });

  MultiplicationState copyWith({
    int? mainNumber,
    int? currentNumber,
    int? correctAnswer,
    List<int>? options,
    int? score,
    bool? isCorrect,
  }) {
    return MultiplicationState(
      mainNumber: mainNumber ?? this.mainNumber,
      currentNumber: currentNumber ?? this.currentNumber,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      score: score ?? this.score,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [
    mainNumber, currentNumber, correctAnswer, options, score, isCorrect,
  ];
}
