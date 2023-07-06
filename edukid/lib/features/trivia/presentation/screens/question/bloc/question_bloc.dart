import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:edukid/features/trivia/data/repositories/auth_repository.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepo quizRepository;
  final user = FirebaseAuth.instance.currentUser!;
  final authRepository = AuthRepository();

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
          emit(QuizErrorState('Non hai selezionato una risposta'));
        } else {
          final question = currentState.question;
          final correctAnswer = question.answer;
          // Check if the submitted answer is correct
          final isCorrect = event.selectedOption == correctAnswer;
          // Emit the result state
          emit(QuizResultState(isCorrect, correctAnswer));

          // Update user's "point" field if the answer is correct
          final userRef =
                FirebaseDatabase.instance.ref().child('users').child(user.uid);
          final currentPointsSnapshot =
              await userRef.child('points').once();
          final currentPoints =
              currentPointsSnapshot.snapshot.value as int? ?? 0;
          int newPoints = currentPoints + (isCorrect ? 10 : -5);
          await userRef.child('points').set(newPoints);
          await authRepository.updateUserPoints(user.uid, newPoints);
        }
      }
    }
  }
}
