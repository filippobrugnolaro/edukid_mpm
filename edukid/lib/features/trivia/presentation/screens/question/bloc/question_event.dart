part of 'question_bloc.dart';

abstract class QuizEvent {
  const QuizEvent();
}

class SubmitAnswerEvent extends QuizEvent {
  final String selectedOption;

  SubmitAnswerEvent(this.selectedOption);
}

class LoadQuizEvent extends QuizEvent {
  const LoadQuizEvent();
}
