import 'package:bloc/bloc.dart';
import 'package:edukid/core/util/Wrappers.dart';
import 'package:edukid/core/util/prepare_quiz.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';
import 'package:edukid/features/trivia/domain/usecases/GetRandomTriviaUseCase.dart';
import 'package:equatable/equatable.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepo quizRepository;

  QuizBloc(this.quizRepository) : super(QuizInitialState()) {
    on<SubmitAnswerEvent>(mapEventToState);
    on<LoadQuizEvent>(mapEventToState);
    on<SelectOptionEvent>(mapEventToState);
  }

  Future<void> mapEventToState(QuizEvent event, Emitter<QuizState> emit) async {
    // load quiz from repo
    if (event is LoadQuizEvent) {
      final question = quizRepository.getQuestion();
      emit(QuizQuestionState(question: question));
    }
    //select Option
    if (event is SelectOptionEvent) {
      final currentState = state;
      if (currentState is QuizQuestionState) {
        final selectedOptionIndex =
            currentState.question.options.indexOf(event.selectedOption);

        if (selectedOptionIndex != currentState.selectedOptionIndex) {
          final updatedState =
              currentState.copyWith(selectedOptionIndex: selectedOptionIndex);
          emit(updatedState);
        }
      }
    }
    // submit answer
    else if (event is SubmitAnswerEvent) {
      final currentState = state;
      if (currentState is QuizQuestionState) {
        if (event.selectedOption == 'null') {
          emit(QuizErrorState('Non hai selezioanto una risposta'));
        } else {
          final question = currentState.question;
          final correctAnswer = question.answer;
          // Check if the submitted answer is correct
          final isCorrect = event.selectedOption == correctAnswer;
          // Emit the result state
          emit(QuizResultState(isCorrect, correctAnswer));
        }
      }
    }
  }
}
