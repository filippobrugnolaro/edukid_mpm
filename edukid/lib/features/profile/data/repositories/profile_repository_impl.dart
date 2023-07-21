import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/features/profile/data/data_sources/profile_data_source.dart';
import 'package:edukid/features/profile/domain/entities/personal_data.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  final AuthAPI authAPI;

  ProfileRepositoryImpl({required this.profileDataSource, required this.authAPI});

  @override
  Future<PersonalData> getUserData() async {
    return await profileDataSource.getUserData(authAPI.getSignedInUserUID());
  }
}