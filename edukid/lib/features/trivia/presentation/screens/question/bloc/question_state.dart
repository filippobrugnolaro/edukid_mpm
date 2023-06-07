part of 'question_bloc.dart';

abstract class QuizState {}

class QuizInitialState extends QuizState {}

class QuizLoadingState extends QuizState {}

class QuizQuestionState extends QuizState {
  final String question;
  final List<String> options;

  QuizQuestionState(this.question, this.options);
}

class QuizResultState extends QuizState {
  final bool isCorrect;
  final String correctOption;

  QuizResultState(this.isCorrect, this.correctOption);
}

class QuizErrorState extends QuizState {
  final String errorMessage;

  QuizErrorState(this.errorMessage);
}

class OptionSelectedState extends QuizState {
  final String selectedOption;

  OptionSelectedState(this.selectedOption);
}
