import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_remote.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceRemote authDataSourceRemote;
  final DatabaseAPI databaseAPI;

  AuthRepositoryImpl({required this.authDataSourceRemote, required this.databaseAPI});

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required int points,
  }) async {

    await authDataSourceRemote.signUp(
        email: email,
        password: password
    );

    if(!authDataSourceRemote.isSignedUpUserNull()) {
      final userUID = authDataSourceRemote.getSignedUpUserUID();
      databaseAPI.setUserData(
          userUID,
          email,
          name,
          surname,
          points
      );
      databaseAPI.setInitialUserStatistics(userUID);
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  })async {

    await authDataSourceRemote.signIn(
        email: email,
        password: password
    );
  }

  @override
  Future<void> signOut() async {
    await authDataSourceRemote.signOut();
  }
}