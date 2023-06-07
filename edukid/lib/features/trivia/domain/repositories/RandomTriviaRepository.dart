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
        question: 'Quanto fa 2x3?', options: ['6', '2', '3', '0'].toList(), answer: '6');
  }
}
