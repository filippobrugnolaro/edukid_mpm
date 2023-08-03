import 'package:firebase_database/firebase_database.dart';

abstract class GetStartedDataSource {
  Future<int> listenToUserPoints(String userUID);
  int getPoints();
  Future<int> getCurrentDone(String userUID, String typeQuestion);
}

class GetStartedDataSourceImpl implements GetStartedDataSource {
  final _database = FirebaseDatabase.instance.ref();
  int points = 0;
  
  @override
  Future<int> listenToUserPoints(String userUID) async {
      final dataSnapshot = await _database.child("users").child(userUID).child("points").once();
      return dataSnapshot.snapshot.value as int;
  }

  @override
  int getPoints(){
    return points;
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
}