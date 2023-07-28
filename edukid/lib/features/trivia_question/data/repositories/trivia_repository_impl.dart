import 'package:dartz/dartz.dart';
import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/core/errors/Exception.dart';
import 'package:edukid/core/errors/Failure.dart';
import 'package:edukid/features/trivia_question/data/data_sources/trivia_data_source.dart';
import 'package:edukid/features/trivia_question/domain/entities/trivia.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';



class TriviaRepositoryImpl implements TriviaRepository {
  final TriviaDataSource triviaDataSource;
  final AuthAPI authAPI;
  final DatabaseAPI databaseAPI;

  TriviaRepositoryImpl({required this.triviaDataSource, required this.authAPI, required this.databaseAPI});

  @override
  Future<Either<Failure, Trivia>> getTrivia(
      String typeQuestion) async {
    try {
      final remoteTrivia =
      await triviaDataSource.getTrivia(typeQuestion);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> updateUserStatistics(bool isAnswerCorrect, String typeQuestion) async {
    await triviaDataSource.updateUserStatistics(isAnswerCorrect, authAPI.getSignedInUserUID(), typeQuestion);
  }

  @override
  Future<void> updateUserPoints(bool isAnswerCorrect) async {
    await triviaDataSource.updateUserPoints(isAnswerCorrect, authAPI.getSignedInUserUID());
  }

  @override
  Future<void> resetAllCurrentToZero() async {
    final userUID = authAPI.getSignedInUserUID();
    if(await databaseAPI.isResetToDo(userUID)) {
      await databaseAPI.resetAllCurrentToZero(userUID);
    }
  }

  @override
  Future<void> copyCurrentToLatest() async {
    final userUID = authAPI.getSignedInUserUID();
    if(await databaseAPI.isResetToDo(userUID)) {
      await databaseAPI.copyCurrentToLatest(userUID);
    }
  }

  @override
  Future<void> setResetToDo(bool boolean) async {
    final userUID = authAPI.getSignedInUserUID();
    if (await databaseAPI.isResetToDo(userUID)) {
      await databaseAPI.setResetToDo(userUID, boolean);
    }
  }

}