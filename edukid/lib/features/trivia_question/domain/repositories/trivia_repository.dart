import '../entities/trivia.dart';

abstract class TriviaRepository {
  Future<Trivia> getTrivia(String typeQuestion);
  Future<void> updateUserStatistics(bool isAnswerCorrect, String typeQuestion);
  Future<void> updateUserPoints(bool isAnswerCorrect);
  Future<void> resetAllCurrentToZero();
  Future<void> copyCurrentToLatest();
  Future<void> setResetToDo(bool boolean);
}