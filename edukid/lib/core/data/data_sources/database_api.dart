import 'package:firebase_database/firebase_database.dart';

  const secondsInOneDay = 86400;

abstract class DatabaseAPI {
  Future<void> setUserData(
      String userUID, String email, String name, String surname, int points);

  Future<void> setInitialUserStatistics(String userUID);

  Future<void> resetAllCurrentToZero(String userUID);

  Future<bool> isResetToDo(String userUID);

  Future<void> copyCurrentToLatest(String userUID);

  Future<void> setResetToDo(String userUID, bool boolean);
}

class DatabaseAPIImpl implements DatabaseAPI {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<void> setUserData(String userUID, String email, String name,
      String surname, int points) async {
    final timestampToDo = (((DateTime.now().millisecondsSinceEpoch/1000).floor())/secondsInOneDay).floor();
    final userData = {
      'email': email,
      'name': name,
      'surname': surname,
      'points': points,
      'timestamp_last_answer': 0,
      'reset_statistics': {'todo': false, 'timestamp_todo': timestampToDo},
      'statistics': {}
    };
    await _database.child('users').child(userUID).set(userData);
  }

  @override
  Future<void> setInitialUserStatistics(String userUID) async {
    final userStatistics = {
      'math': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'geography': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'history': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'science': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'global': {'correct': 0, 'done': 0}
    };
    await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .set(userStatistics);
  }

  Future<void> _resetCurrentCategory(String userUID, String typeQuestion) async {
    await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('current')
        .child('correct')
        .set(0);

    await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('current')
        .child('done')
        .set(0);
  }

  Future<bool> _isLastToDoToday(String userUID) async {
    final lastTimestampAnswerSnapShot = await _database
        .child('users')
        .child(userUID)
        .child('reset_statistics')
        .child('timestamp_todo')
        .once();
    final lastTimestampToDoDay = ((lastTimestampAnswerSnapShot.snapshot.value as int)/86400).floor();
    final timestampToDoNow = (((DateTime.now().millisecondsSinceEpoch/1000).floor())/secondsInOneDay).floor();
    return lastTimestampToDoDay == timestampToDoNow;
  }

  @override
  Future<bool> isResetToDo(String userUID) async {
    if(!await _isLastToDoToday(userUID)){
      await _database
          .child('users')
          .child(userUID)
          .child('reset_statistics')
          .child('todo')
          .set(true);
    }
    final resetToDoSnapshot = await _database
        .child('users')
        .child(userUID)
        .child('reset_statistics')
        .child('todo')
        .once();
    return resetToDoSnapshot.snapshot.value as bool;
  }

  @override
  Future<void> setResetToDo(String userUID, bool boolean) async {
    await _database
        .child('users')
        .child(userUID)
        .child('reset_statistics')
        .child('todo')
        .set(boolean);
    final timestampToDoNow = (((DateTime.now().millisecondsSinceEpoch/1000).floor())/secondsInOneDay).floor();
    await _database
        .child('users')
        .child(userUID)
        .child('reset_statistics')
        .child('timestamp_todo')
        .set(timestampToDoNow);
  }

  @override
  Future<void> resetAllCurrentToZero(String userUID) async {
      await _resetCurrentCategory(userUID, 'math');
      await _resetCurrentCategory(userUID, 'geography');
      await _resetCurrentCategory(userUID, 'history');
      await _resetCurrentCategory(userUID, 'science');
  }

  Future<void> _copyCurrentToLatestCategory(String userUID, String typeQuestion) async {
    final currentDataSnapshot = await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('current')
        .once();

    await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('latest')
        .set(currentDataSnapshot.snapshot.value);
  }

  @override
  Future<void> copyCurrentToLatest(String userUID) async {
    await _copyCurrentToLatestCategory(userUID, 'math');
    await _copyCurrentToLatestCategory(userUID, 'geography');
    await _copyCurrentToLatestCategory(userUID, 'history');
    await _copyCurrentToLatestCategory(userUID, 'science');
  }

}
