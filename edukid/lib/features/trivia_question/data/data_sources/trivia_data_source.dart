import 'dart:convert';
import 'dart:math';

import 'package:edukid/core/errors/Exception.dart';
import 'package:edukid/features/trivia_question/data/models/trivia_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class TriviaDataSource {
  Future<TriviaModel> getTrivia(String typeQuestion);
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
  Future<void> updateUserPoints(bool isAnswerCorrect, String userUID) async {
    final userRef = _database.child("users").child(userUID);
    final currentPointsSnapshot = await userRef.child("points").once();
    final currentPoints = currentPointsSnapshot.snapshot.value as int? ?? 0;
    int newPoints = currentPoints + (isAnswerCorrect ? 10 : -5);
    await userRef.child("points").set(newPoints);
  }
}