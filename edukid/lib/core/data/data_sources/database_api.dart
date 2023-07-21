import 'package:firebase_database/firebase_database.dart';

abstract class DatabaseAPI {
  Future<void> setUserData(String userUID, String email, String name, String surname, int points);
}

class DatabaseAPIImpl implements DatabaseAPI {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<void> setUserData(String userUID, String email, String name, String surname, int points) async {
    final userData = {
      'email': email,
      'name': name,
      'surname': surname,
      'points': points,
    };
    await _database.child('users').child(userUID).set(userData);
  }
}