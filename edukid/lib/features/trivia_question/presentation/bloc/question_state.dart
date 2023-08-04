part of 'question_bloc.dart';

abstract class TriviaState {
  const TriviaState();

  TriviaState copyWith();
}

class TriviaInitialState extends TriviaState {
  @override
  TriviaInitialState copyWith() {
    return TriviaInitialState();
  }
}

class TriviaLoadingState extends TriviaState {
  @override
  TriviaLoadingState copyWith() {
    return TriviaLoadingState();
  }
}

class TriviaQuestionState extends TriviaState {
  final Trivia question;
  final int selectedOptionIndex;

  TriviaQuestionState(
      {required this.question,
      this.selectedOptionIndex = -1});

  @override
  TriviaQuestionState copyWith(
      {Trivia? question, int? selectedOptionIndex}) {
    return TriviaQuestionState(
      question: question ?? this.question,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }
}

class TriviaResultState extends TriviaState {
  final bool isCorrect;
  final String correctOption;

  TriviaResultState(this.isCorrect, this.correctOption);

  @override
  TriviaResultState copyWith({bool? isCorrect, String? correctOption}) {
    return TriviaResultState(
      isCorrect ?? this.isCorrect,
      correctOption ?? this.correctOption,
    );
  }
}

class TriviaErrorState extends TriviaState {
  final String errorMessage;

  TriviaErrorState(this.errorMessage);

  @override
  TriviaErrorState copyWith({String? errorMessage}) {
    return TriviaErrorState(
      errorMessage ?? this.errorMessage,
    );
  }
}

class OptionSelectedState extends TriviaState {
  final String selectedOption;

  OptionSelectedState(this.selectedOption);

  @override
  OptionSelectedState copyWith({String? selectedOption}) {
    return OptionSelectedState(
      selectedOption ?? this.selectedOption,
    );
  }
}
