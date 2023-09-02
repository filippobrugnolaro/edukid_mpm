import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/core/network/network_info.dart';
import 'package:edukid/features/trivia_question/data/data_sources/trivia_data_source.dart';
import 'package:edukid/features/trivia_question/domain/entities/trivia.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';

class TriviaRepositoryImpl implements TriviaRepository {
  final TriviaDataSource triviaDataSource;
  final AuthAPI authAPI;
  final DatabaseAPI databaseAPI;
  final NetworkInfo networkInfo;

  TriviaRepositoryImpl(
      {required this.triviaDataSource,
      required this.authAPI,
      required this.databaseAPI,
      required this.networkInfo});

  @override
  Future<Trivia> getTrivia(String typeQuestion) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteTrivia = await triviaDataSource.getTrivia(typeQuestion);
        return remoteTrivia;
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> updateUserStatistics(
      bool isAnswerCorrect, String typeQuestion) async {
    try {
      if (await networkInfo.isConnected) {
        await triviaDataSource.updateUserStatistics(
            isAnswerCorrect, authAPI.getSignedInUserUID(), typeQuestion);
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> updateUserPoints(bool isAnswerCorrect) async {
    try {
      if (await networkInfo.isConnected) {
        await triviaDataSource.updateUserPoints(
            isAnswerCorrect, authAPI.getSignedInUserUID());
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> resetAllCurrentToZero() async {
    try {
      if (await networkInfo.isConnected) {
        final userUID = authAPI.getSignedInUserUID();
        if (await databaseAPI.isResetToDo(userUID)) {
          await databaseAPI.resetAllCurrentToZero(userUID);
        }
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> copyCurrentToLatest() async {
    try {
      if (await networkInfo.isConnected) {
        final userUID = authAPI.getSignedInUserUID();
        if (await databaseAPI.isResetToDo(userUID)) {
          await databaseAPI.copyCurrentToLatest(userUID);
        }
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> setResetToDo(bool boolean) async {
    try {
      if (await networkInfo.isConnected) {
        final userUID = authAPI.getSignedInUserUID();
        if (await databaseAPI.isResetToDo(userUID)) {
          await databaseAPI.setResetToDo(userUID, boolean);
        }
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
