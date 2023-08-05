import 'package:firebase_database/firebase_database.dart';

abstract class GetStartedDataSource {
  Future<int> listenToUserPoints(String userUID);
  Future<int> getCurrentDone(String userUID, String typeQuestion);
  Future<void> setWizardToDisplay(String userUID, bool boolean);
  Future<bool> getWizardToDisplay(String userUID);
}

class GetStartedDataSourceImpl implements GetStartedDataSource {
  final _database = FirebaseDatabase.instance.ref();
  
  @override
  Future<int> listenToUserPoints(String userUID) async {
      final dataSnapshot = await _database.child("users").child(userUID).child("points").once();
      return dataSnapshot.snapshot.value as int;
  }
  @override
  Future<int> getCurrentDone(String userUID, String typeQuestion) async {
    final currentDoneSnapshot = await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('current')
        .child('done')
        .get();
    return currentDoneSnapshot.value as int;
  }

  @override
  Future<void> setWizardToDisplay(String userUID, bool boolean) async {
    await _database
        .child('users')
        .child(userUID)
        .child('wizard_to_display')
        .set(false);
  }
  @override
  Future<bool> getWizardToDisplay(String userUID) async {
    final wizardToDisplaySnapshot = await _database
        .child('users')
        .child(userUID)
        .child('wizard_to_display')
        .get();
    return wizardToDisplaySnapshot.value as bool;
  }

}