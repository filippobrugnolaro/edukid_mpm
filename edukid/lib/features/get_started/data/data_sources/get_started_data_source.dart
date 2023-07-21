import 'package:firebase_database/firebase_database.dart';

abstract class GetStartedDataSource {
  Future<int> listenToUserPoints(String userUID);
  int getPoints();
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
}