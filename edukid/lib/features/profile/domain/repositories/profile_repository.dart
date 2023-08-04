import 'package:edukid/features/profile/domain/entities/personal_data.dart';

abstract class ProfileRepository {
  Future<PersonalData> getUserData();
  Future<bool> isDeviceConnected();
}