import 'package:dartz/dartz.dart';
import 'package:edukid/core/usecase/UseCase.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';

import '../../../../core/errors/Failure.dart';
import '../../../../core/util/Wrappers.dart';
import '../repositories/RandomTriviaRepository.dart';

class GetRandomTriviaUseCase extends UseCase<RandomTrivia, Params> {
  final RandomTriviaRepository repository;

  GetRandomTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, RandomTrivia>> call(Params params) async {
    return await repository.getRandomTrivia(
        params.typeQuestion, params.numberQuestion);
  }

  RandomTrivia getQuestion(
      {Params params =
          const Params(typeQuestion: 'math', numberQuestion: '3')}) {
    /*return await repository.getRandomTrivia(
        params.typeQuestion, params.numberQuestion);*/
    return RandomTrivia(
        question: 'ciao', options: ['a', 'b', 'c', 'd'].toList(), answer: 'a');
  }
}
