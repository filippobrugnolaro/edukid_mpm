import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../entities/RandomTrivia.dart';

abstract class RandomTriviaRepository {
  Future<Either<Failure, RandomTrivia>> getRandomTrivia(String typeQuestion, String numberQuestion);
}
