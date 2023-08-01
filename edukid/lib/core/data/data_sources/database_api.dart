import 'package:firebase_database/firebase_database.dart';

import '../../utils/utils.dart';

abstract class DatabaseAPI {
  Future<void> setUserData(
      String userUID, String email, String name, String surname, int points);

  Future<void> setInitialUserStatistics(String userUID);

  Future<void> resetAllCurrentToZero(String userUID);

  Future<bool> isResetToDo(String userUID);

  Future<void> copyCurrentToLatest(String userUID);

  Future<void> setResetToDo(String userUID, bool boolean);

  Future<int> getCurrentDone(String userUID, String typeQuestion);
}

class DatabaseAPIImpl implements DatabaseAPI {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<void> setUserData(String userUID, String email, String name,
      String surname, int points) async {
    final timestampToDo =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final userData = {
      'email': email,
      'name': name,
      'surname': surname,
      'points': points,
      'reset_statistics': {'todo': false, 'timestamp_todo': timestampToDo},
      'statistics': {}
    };
    await _database.child('users').child(userUID).set(userData);
  }

  @override
  Future<void> setInitialUserStatistics(String userUID) async {
    final userStatistics = {
      'Mathematics': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'Geography': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'History': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'Science': {
        'latest': {'timestamp': 0, 'correct': 0, 'done': 0},
        'current': {'timestamp': 0, 'correct': 0, 'done': 0},
        'total': {'correct': 0, 'done': 0}
      },
      'Global': {'timestamp': 0, 'correct': 0, 'done': 0}
    };
    await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .set(userStatistics);
  }

  Future<void> _resetCurrentCategory(
      String userUID, String typeQuestion) async {
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
        .get();
    final lastTimestampToDoDay =
        (((lastTimestampAnswerSnapShot.value as int).floor()) / secondsInOneDay)
            .floor();
    final timestampToDoNow =
        (((DateTime.now().millisecondsSinceEpoch / 1000).floor()) /
                secondsInOneDay)
            .floor();
    return lastTimestampToDoDay == timestampToDoNow;
  }

  @override
  Future<bool> isResetToDo(String userUID) async {
    if (!await _isLastToDoToday(userUID)) {
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
    final timestampToDoNow =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    await _database
        .child('users')
        .child(userUID)
        .child('reset_statistics')
        .child('timestamp_todo')
        .set(timestampToDoNow);
  }

  @override
  Future<void> resetAllCurrentToZero(String userUID) async {
    await _resetCurrentCategory(userUID, 'Mathematics');
    await _resetCurrentCategory(userUID, 'Geography');
    await _resetCurrentCategory(userUID, 'History');
    await _resetCurrentCategory(userUID, 'Science');
  }

  Future<void> _copyCurrentToLatestCategory(
      String userUID, String typeQuestion) async {
    bool hasAnswered = await _hasAnsweredToCategory(userUID, typeQuestion);
    if (hasAnswered) {
      final currentDataSnapshot = await _database
          .child('users')
          .child(userUID)
          .child('statistics')
          .child(typeQuestion)
          .child('current')
          .get();

      await _database
          .child('users')
          .child(userUID)
          .child('statistics')
          .child(typeQuestion)
          .child('latest')
          .set(currentDataSnapshot.value);
    }
  }

  Future<bool> _hasAnsweredToCategory(
      String userUID, String typeQuestion) async {
    final hasAnswered = await _database
        .child('users')
        .child(userUID)
        .child('statistics')
        .child(typeQuestion)
        .child('current')
        .child('done')
        .get();
    return hasAnswered.exists && hasAnswered.value as int > 0;
  }

  @override
  Future<void> copyCurrentToLatest(String userUID) async {
    await _copyCurrentToLatestCategory(userUID, 'Mathematics');
    await _copyCurrentToLatestCategory(userUID, 'Geography');
    await _copyCurrentToLatestCategory(userUID, 'History');
    await _copyCurrentToLatestCategory(userUID, 'Science');
  }

  // if you want to get current correct, latest correct and latest done:
  // substitute with latest with current and correct with done eventually
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
