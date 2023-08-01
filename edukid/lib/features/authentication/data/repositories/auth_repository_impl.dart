import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_local.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_remote.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceRemote authDataSourceRemote;
  final AuthDataSourceLocal authDataSourceLocal;
  final DatabaseAPI databaseAPI;

  AuthRepositoryImpl({required this.authDataSourceRemote, required this.authDataSourceLocal, required this.databaseAPI});

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

    await authDataSourceLocal.setAuthState(authDataSourceRemote.getSignedInUserUID(), true);
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
    await authDataSourceLocal.setAuthState(authDataSourceRemote.getSignedInUserUID(), true);
  }

  @override
  Future<void> signOut() async {
    final userUID = authDataSourceRemote.getSignedInUserUID();
    await authDataSourceRemote.signOut();
    await authDataSourceLocal.setAuthState(userUID, false);
  }
}