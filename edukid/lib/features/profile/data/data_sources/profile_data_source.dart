import 'dart:convert';

import 'package:edukid/features/profile/data/models/personal_data_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class ProfileDataSource {
  Future<PersonalDataModel> getUserData(String userUID);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<PersonalDataModel> getUserData(String userUID) async {
    final userDataSnapshot = await _database.child("users").child(userUID).once();
    return PersonalDataModel.fromJson(jsonDecode(jsonEncode(userDataSnapshot.snapshot.value)));
  }
}