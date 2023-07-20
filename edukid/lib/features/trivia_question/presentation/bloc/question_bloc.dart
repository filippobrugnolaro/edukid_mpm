import 'package:bloc/bloc.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';
import 'package:edukid/features/trivia_question/domain/entities/trivia.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';

part 'question_event.dart';
part 'question_state.dart';

  const String serverFailureMessage = "Server Failure";

class TriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final TriviaRepository triviaRepository;
  final AuthRepository authRepository;

  TriviaBloc({required this.triviaRepository, required this.authRepository}) : super(TriviaInitialState()) {
    on<SubmitTriviaAnswerEvent>(mapEventToState);
    on<LoadTriviaEvent>(mapEventToState);
    on<SelectTriviaOptionEvent>(mapEventToState);
  }

  Future<void> mapEventToState(TriviaEvent event, Emitter<TriviaState> emit) async {
    // load quiz from repo
    if (event is LoadTriviaEvent) {
      final question = await triviaRepository.getTrivia(event.typeQuestion);
      question.fold(
              (failure) => emit(TriviaErrorState(serverFailureMessage)),
              (question) => emit(TriviaQuestionState(question: question))
      );
    }
    //select Option
    if (event is SelectTriviaOptionEvent) {
      final currentState = state;
      if (currentState is TriviaQuestionState) {
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
    else if (event is SubmitTriviaAnswerEvent) {
      final currentState = state;
      if (currentState is TriviaQuestionState) {
        if (event.selectedOption == 'null') {
          emit(TriviaErrorState('Please select and option'));
        } else {
          final correctAnswer = currentState.question.answer;
          // Check if the submitted answer is correct
          final isAnswerCorrect = event.selectedOption == correctAnswer;
          // Emit the result state
          emit(TriviaResultState(isAnswerCorrect, correctAnswer));

          // Update user's "points" field if the answer is correct
          await triviaRepository.updateUserPoints(isAnswerCorrect, authRepository.getSignedInUserUID());
        }
      }
    }
  }
}
