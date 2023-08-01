import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/features/get_started/data/data_sources/get_started_data_source.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';

class GetStartedRepositoryImpl implements GetStartedRepository {
  final GetStartedDataSource getStartedDataSource;
  final AuthAPI authAPI;
  final DatabaseAPI databaseAPI;

  GetStartedRepositoryImpl({required this.getStartedDataSource, required this.authAPI, required this.databaseAPI});

  @override
  Future<int> listenToUserPoints() async {
    return await getStartedDataSource.listenToUserPoints(authAPI.getSignedInUserUID());
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
    if(await databaseAPI.isResetToDo(userUID)) {
      await databaseAPI.setResetToDo(userUID, boolean);
    }
  }

  // if it is only for get_started move getCurrentDone call from databaseAPI to getStartedDataSource
  // if it has to be added also to statistics leave it here so it can be called from potentially every feature
  // removing the call also from abstract class and adding the call to the other abstract
  // the pattern is the same so if you
  Future<List<int>> getAllCurrentDone() async {
    final userUID = authAPI.getSignedInUserUID();
    List<int> listCurrentDone = [];
    listCurrentDone.add(await databaseAPI.getCurrentDone(userUID, 'Mathematics'));
    listCurrentDone.add(await databaseAPI.getCurrentDone(userUID, 'Geography'));
    listCurrentDone.add(await databaseAPI.getCurrentDone(userUID, 'History'));
    listCurrentDone.add(await databaseAPI.getCurrentDone(userUID, 'Science'));
    return listCurrentDone;
  }

}