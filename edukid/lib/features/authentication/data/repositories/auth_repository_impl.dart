import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/core/network/network_info.dart';
import 'package:edukid/di_container.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_remote.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceRemote authDataSourceRemote;
  final DatabaseAPI databaseAPI;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.authDataSourceRemote,
      required this.databaseAPI,
      required this.networkInfo});

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required int points,
  }) async {
    try {
      if (await sl<NetworkInfo>().isConnected) {
        await authDataSourceRemote.signUp(email: email, password: password);

        if (!authDataSourceRemote.isSignedUpUserNull()) {
          final userUID = authDataSourceRemote.getSignedUpUserUID();
          databaseAPI.setUserData(userUID, email, name, surname, points);
          databaseAPI.setInitialUserStatistics(userUID);
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
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (await sl<NetworkInfo>().isConnected) {
        await authDataSourceRemote.signIn(email: email, password: password);
      } else {
        throw Exception(
            'Sembra non ci sia connessione ad interent. Connettiti ad una rete wifi o usa i dati mobili');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Future<void> signOut() async {
    await authDataSourceRemote.signOut();
  }
}
