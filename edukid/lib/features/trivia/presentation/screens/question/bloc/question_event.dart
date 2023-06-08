part of 'question_bloc.dart';

abstract class QuizEvent {
  const QuizEvent();
}

class LoadQuizEvent extends QuizEvent {
  const LoadQuizEvent();
}

class SelectOptionEvent extends QuizEvent {
  final String selectedOption;

  SelectOptionEvent(this.selectedOption);
}

class SubmitAnswerEvent extends QuizEvent {
  final String selectedOption;

  SubmitAnswerEvent(this.selectedOption);
}


class AnswerOption {
  final String text;
  bool isSelected;

  AnswerOption({required this.text, this.isSelected = false});

  AnswerOption copyWith({String? text, bool? isSelected}) {
    return AnswerOption(
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}


