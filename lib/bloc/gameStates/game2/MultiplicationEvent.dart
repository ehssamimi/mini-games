import 'package:equatable/equatable.dart';

abstract class MultiplicationEvent extends Equatable {
  const MultiplicationEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQuestion extends MultiplicationEvent {}

class SubmitAnswer extends MultiplicationEvent {
  final int answer;
  const SubmitAnswer(this.answer);
  @override
  List<Object?> get props => [answer];
}
