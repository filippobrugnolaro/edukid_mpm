import 'package:edukid/core/data/data_sources/auth_data_source.dart';
import 'package:edukid/core/data/data_sources/database_data_source.dart';
import 'package:edukid/features/profile/domain/entities/personal_data.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DatabaseDataSource databaseDataSource;
  final AuthDataSource authDataSource;

  ProfileRepositoryImpl({required this.databaseDataSource, required this.authDataSource});

  @override
  Future<PersonalData> getUserData() async {
    return await databaseDataSource.getUserData(authDataSource.getSignedInUserUID());
  }
}