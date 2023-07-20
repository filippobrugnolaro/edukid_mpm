import 'dart:convert';
import 'dart:math';

import 'package:edukid/core/errors/Exception.dart';
import 'package:edukid/features/profile/data/models/personal_data_model.dart';
import 'package:edukid/features/trivia_question/data/models/trivia_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class DatabaseDataSource {
  Future<void> setUserData(String userUID, String email, String name, String surname, int points);
//  Future<void> updateUserPoints(String userUID, int points);
  Future<PersonalDataModel> getUserData(String userUID);
  Future<TriviaModel> getTrivia(String typeQuestion);
  Future<void> updateUserPoints(bool isAnswerCorrect, String userUID);
}

class DatabaseDataSourceImpl implements DatabaseDataSource {
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

/*  @override
  Future<void> updateUserPoints(String userUID, int points) async {
    try {
      // Update the "points" field in the user node
      await _database.child('users').child(userUID).child('points').set(points);
    } catch (error) {
      // Handle any errors that occur during the update
      print('Error updating user points: $error');
      throw error;
    }
  }*/

  @override
  Future<PersonalDataModel> getUserData(String userUID) async {
    final userDataSnapshot = await _database.child("users").child(userUID).once();
      return PersonalDataModel.fromJson(json.decode(userDataSnapshot.snapshot.value!.toString()));
  }

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
      var optionsList = [];
      final optionsDecoded = jsonDecode(jsonEncode(selectedQuestion.value))["options"];
      print("$optionsDecoded");
      for(int i=1; i<5; i++) {
        optionsList.add(optionsDecoded["option" + i.toString()]);
      }
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