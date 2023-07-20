import 'package:dartz/dartz.dart';
import 'package:edukid/core/data/data_sources/database_data_source.dart';
import 'package:edukid/core/errors/Exception.dart';
import 'package:edukid/core/errors/Failure.dart';
import 'package:edukid/features/trivia_question/domain/entities/trivia.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';



class TriviaRepositoryImpl implements TriviaRepository {
  final DatabaseDataSource databaseDataSource;

  TriviaRepositoryImpl({required this.databaseDataSource});

  @override
  Future<Either<Failure, Trivia>> getTrivia(
      String typeQuestion) async {
    try {
      final remoteTrivia =
      await databaseDataSource.getTrivia(typeQuestion);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> updateUserPoints(bool isAnswerCorrect, String userUID) async {
    await databaseDataSource.updateUserPoints(isAnswerCorrect, userUID);
  }
}