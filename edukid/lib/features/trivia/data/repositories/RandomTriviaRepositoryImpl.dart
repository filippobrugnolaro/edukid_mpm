import 'package:dartz/dartz.dart';
import 'package:edukid/core/errors/Failure.dart';
import 'package:edukid/features/trivia/data/datasources/RandomTriviaDataSource.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';

import '../../../../core/errors/Exception.dart';

class RandomTriviaRepositoryImpl implements RandomTriviaRepository{
  final RandomTriviaRemoteDataSource remoteDataSource;

  RandomTriviaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RandomTrivia>> getRandomTrivia(String typeQuestion, String numberQuestion) async {
    try {
      final remoteTrivia = await remoteDataSource.getRandomTrivia(typeQuestion, numberQuestion);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}