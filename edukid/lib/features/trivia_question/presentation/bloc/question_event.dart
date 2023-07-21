part of 'question_bloc.dart';

abstract class TriviaEvent {
  const TriviaEvent();
}

class LoadTriviaEvent extends TriviaEvent {
  final String typeQuestion;
  const LoadTriviaEvent(this.typeQuestion);
}

class SelectTriviaOptionEvent extends TriviaEvent {
  final String selectedOption;

  SelectTriviaOptionEvent(this.selectedOption);
}

class SubmitTriviaAnswerEvent extends TriviaEvent {
  final String selectedOption;

  SubmitTriviaAnswerEvent(this.selectedOption);
}

// TODO positioning better
class TriviaAnswerOption {
  final String text;
  bool isSelected;

  TriviaAnswerOption({required this.text, this.isSelected = false});

  TriviaAnswerOption copyWith({String? text, bool? isSelected}) {
    return TriviaAnswerOption(
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}


