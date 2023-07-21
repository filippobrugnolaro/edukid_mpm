import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/features/get_started/data/data_sources/get_started_data_source.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';

class GetStartedRepositoryImpl implements GetStartedRepository {
  final GetStartedDataSource getStartedDataSource;
  final AuthAPI authAPI;

  GetStartedRepositoryImpl({required this.getStartedDataSource, required this.authAPI});

  @override
  Future<int> listenToUserPoints() async {
    return await getStartedDataSource.listenToUserPoints(authAPI.getSignedInUserUID());
  }
}