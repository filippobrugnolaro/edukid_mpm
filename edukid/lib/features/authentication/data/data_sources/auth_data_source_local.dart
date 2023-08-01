import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDataSourceLocal {
  Future<void> setAuthState(String userUID, bool boolean);
  Future<bool> getAuthState(String userUID);
}

class AuthDataSourceLocalImpl implements AuthDataSourceLocal {
  final SharedPreferences sharedPreferences;

  AuthDataSourceLocalImpl({required this.sharedPreferences});

  @override
  Future<void> setAuthState(String userUID, bool boolean) async {
    final prefs = sharedPreferences;
    await prefs.setBool(userUID, boolean);
  }

  @override
  Future<bool> getAuthState(String email) async {
    final prefs = sharedPreferences;
    return prefs.getBool(email)!;
  }
}