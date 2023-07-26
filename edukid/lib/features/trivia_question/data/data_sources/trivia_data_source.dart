import 'dart:convert';
import 'dart:math';

import 'package:edukid/core/errors/Exception.dart';
import 'package:edukid/features/trivia_question/data/models/trivia_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class TriviaDataSource {
  Future<TriviaModel> getTrivia(String typeQuestion);
  Future<void> updateUserStatistics(bool isAnswerCorrect, String userUID, String typeQuestion);
  Future<void> updateUserPoints(bool isAnswerCorrect, String userUID);
}

class TriviaDataSourceImpl implements TriviaDataSource {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<TriviaModel> getTrivia(String typeQuestion) async {

    final response = await _database.child("/subject").child("/$typeQuestion").get();
    if (response.exists) {
      final random = Random().nextInt(response.children.length);
      final selectedQuestion =
      await _database.child("/subject")
          .child("/$typeQuestion")
          .child("question$random")
          .get();
      return TriviaModel.fromJson(jsonDecode(jsonEncode(selectedQuestion.value)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateUserStatistics(bool isAnswerCorrect, String userUID, String typeQuestion) async {
    final userRef = _database.child("users").child(userUID);
    await _currentCorrectUpdate(userRef, typeQuestion, isAnswerCorrect);
    await _currentDoneUpdate(userRef, typeQuestion);
    await _globalCorrectUpdate(userRef, isAnswerCorrect);
    await _globalDoneUpdate(userRef);
  }

  @override
  Future<void> updateUserPoints(bool isAnswerCorrect, String userUID) async {
    final userRef = _database.child("users").child(userUID);
    final currentPointsSnapshot =
      await userRef
          .child("points")
          .once();
    final currentPoints = currentPointsSnapshot.snapshot.value as int? ?? 0;
    final newPoints = currentPoints + (isAnswerCorrect ? 10 : -5);
    await userRef
        .child("points")
        .set(newPoints);
  }

  Future<void> _currentCorrectUpdate(DatabaseReference userRef, String typeQuestion, bool isAnswerCorrect) async {

    final valueCorrectSnapshot =
      await userRef
          .child("statistics")
          .child(typeQuestion)
          .child("current")
          .child("correct")
          .once();
    final currentCorrect = valueCorrectSnapshot.snapshot.value as int? ?? 0;
    final newCorrect = currentCorrect + (isAnswerCorrect ? 1 : 0);
    await userRef
        .child("statistics")
        .child(typeQuestion)
        .child("current")
        .child("correct")
        .set(newCorrect);
  }

  Future<void> _currentDoneUpdate(DatabaseReference userRef, String typeQuestion) async {

    final valueDoneSnapshot =
    await userRef
        .child("statistics")
        .child(typeQuestion)
        .child("current")
        .child("done")
        .once();
    final currentDone = valueDoneSnapshot.snapshot.value as int? ?? 0;
    final newDone = currentDone + 1;
    await userRef
        .child("statistics")
        .child(typeQuestion)
        .child("current")
        .child("done")
        .set(newDone);
  }

  Future<void> _globalCorrectUpdate(DatabaseReference userRef, bool isAnswerCorrect) async {

    final valueGlobalCorrectSnapshot =
    await userRef
        .child("statistics")
        .child("global")
        .child("correct")
        .once();
    final valueGlobalCorrect = valueGlobalCorrectSnapshot.snapshot.value as int? ?? 0;
    final newGlobalCorrect = valueGlobalCorrect + (isAnswerCorrect ? 1 : 0);
    await userRef
        .child("statistics")
        .child("global")
        .child("correct")
        .set(newGlobalCorrect);
  }

  Future<void> _globalDoneUpdate(DatabaseReference userRef) async {

    final valueGlobalDoneSnapshot =
    await userRef
        .child("statistics")
        .child("global")
        .child("done")
        .once();
    final currentGlobalDone = valueGlobalDoneSnapshot.snapshot.value as int? ?? 0;
    final newGlobalDone = currentGlobalDone + 1;
    await userRef
        .child("statistics")
        .child("global")
        .child("done")
        .set(newGlobalDone);
  }
}