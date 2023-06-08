part of 'question_bloc.dart';

abstract class QuizState {
  const QuizState();

  QuizState copyWith();
}

class QuizInitialState extends QuizState {
  @override
  QuizInitialState copyWith() {
    return QuizInitialState();
  }
}

class QuizLoadingState extends QuizState {
    @override
  QuizLoadingState copyWith() {
    return QuizLoadingState();
  }
}

class QuizQuestionState extends QuizState {
  final String question;
  final List<String> options;
  final int selectedOptionIndex;

  QuizQuestionState({required this.question, required this.options, this.selectedOptionIndex = -1});

  @override
  QuizQuestionState copyWith({String? question, List<String>? options, int? selectedOptionIndex}) {
    return QuizQuestionState(
      question: question ?? this.question,
      options: options ?? this.options,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }
}

class QuizResultState extends QuizState {
  final bool isCorrect;
  final String correctOption;

  QuizResultState(this.isCorrect, this.correctOption);

  @override
  QuizResultState copyWith({bool? isCorrect, String? correctOption}) {
    return QuizResultState(
      isCorrect ?? this.isCorrect,
      correctOption ?? this.correctOption,
    );
  }
}

class QuizErrorState extends QuizState {
  final String errorMessage;

  QuizErrorState(this.errorMessage);

  @override
  QuizErrorState copyWith({String? errorMessage}) {
    return QuizErrorState(
      errorMessage ?? this.errorMessage,
    );
  }
}

class OptionSelectedState extends QuizState {
  final String selectedOption;

  OptionSelectedState(this.selectedOption);

  @override
  OptionSelectedState copyWith({String? selectedOption}) {
    return OptionSelectedState(
      selectedOption ?? this.selectedOption,
    );
  }
}
