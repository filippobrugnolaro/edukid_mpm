import 'dart:convert';

import 'package:edukid/features/statistics/data/models/entry_leaderboard_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class LeaderboardDataSource {
  Future<List<EntryLeaderboardModel>> getAllEntriesLeaderboard();
  Future<String> getEmailFromUID(String userUID);

}

class LeaderboardDataSourceImpl implements LeaderboardDataSource {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<List<EntryLeaderboardModel>> getAllEntriesLeaderboard() async {
    List<Object> listObjects = [];
    await _database.child('users').get().then((snapshot) => {
          for (final userUID in snapshot.children)
            {listObjects.add(userUID.value!)}
        });
    List<EntryLeaderboardModel> listModels = [];
    listModels.sort((e1, e2) {
      final int sortByPoints = -e1.points.compareTo(e2.points);
      if (sortByPoints == 0) {
        final int sortByCorrect = -e1.correct.compareTo(e2.correct);
        if (sortByCorrect == 0) {
          return e1.lastTimestamp.compareTo(e2.lastTimestamp);
        }
        return sortByCorrect;
      }
      return sortByPoints;
    });
    int rank = 1;
    for (var element in listObjects) {
      listModels.add(EntryLeaderboardModel.fromJson(
          jsonDecode(jsonEncode(element)), rank));
      rank++;
    }
    // sort with - => desc
    // sort with + => asc
    
    return listModels;
  }

  @override
  Future<String> getEmailFromUID(String userUID) async {
    final emailSnapshot =
        await _database.child('users').child(userUID).child('email').get();
    return emailSnapshot.value.toString();
  }
}
