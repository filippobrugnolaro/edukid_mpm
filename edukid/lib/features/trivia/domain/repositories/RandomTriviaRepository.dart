import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../entities/RandomTrivia.dart';

abstract class RandomTriviaRepository {
  Future<Either<Failure, RandomTrivia>> getRandomTrivia(
      String typeQuestion, String numberQuestion);
}

class QuizRepo{
    RandomTrivia getQuestion(){
      return RandomTrivia(
        question: 'ciao', options: ['a', 'b', 'c', 'd'].toList(), answer: 'a');
  }
}
