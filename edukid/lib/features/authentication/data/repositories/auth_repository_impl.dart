import 'package:edukid/core/data/data_sources/auth_data_source.dart';
import 'package:edukid/core/data/data_sources/database_data_source.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final DatabaseDataSource databaseDataSource;

  AuthRepositoryImpl({required this.authDataSource, required this.databaseDataSource});

  @override
  Future<void> signInWithGoogle() async {
    await authDataSource.signInWithGoogle();
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required int points,
  }) async {

    await authDataSource.signUp(
        email: email,
        password: password
    );

    if(!authDataSource.isSignedUpUserNull()) {
      databaseDataSource.setUserData(
          authDataSource.getSignedUpUserUID(),
          email,
          name,
          surname,
          points
      );
    }


  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  })async {

    await authDataSource.signIn(
        email: email,
        password: password
    );

  }

  @override
  Future<void> signOut() async {
    await authDataSource.signOut();
  }

  @override
  String getSignedInUserUID() {
    return authDataSource.getSignedInUserUID();
  }
}