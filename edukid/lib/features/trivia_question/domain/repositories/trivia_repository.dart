import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../entities/trivia.dart';

abstract class TriviaRepository {
  Future<Either<Failure, Trivia>> getTrivia(String typeQuestion);
  Future<void> updateUserStatistics(bool isAnswerCorrect, String typeQuestion);
  Future<void> updateUserPoints(bool isAnswerCorrect);
  Future<void> resetAllCurrentToZero();
  Future<void> copyCurrentToLatest();
  Future<void> setResetToDo(bool boolean);
}