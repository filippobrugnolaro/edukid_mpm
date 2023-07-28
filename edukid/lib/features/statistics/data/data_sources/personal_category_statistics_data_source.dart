import 'dart:convert';

import 'package:edukid/features/statistics/data/models/personal_category_statistics_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class PersonalCategoryStatisticsDataSource{
  Future<PersonalCategoryStatisticsModel> getStatisticsByCategory(String userUID, String category);
}

class PersonalCategoryStatisticsDataSourceImpl implements PersonalCategoryStatisticsDataSource{
  final _database = FirebaseDatabase.instance.ref();

  @override
  Future<PersonalCategoryStatisticsModel> getStatisticsByCategory(String userUID, String category) async {
    final statisticsSnapshot = await _database.child('users').child(userUID).child('statistics').get();
    return PersonalCategoryStatisticsModel.fromJson(jsonDecode(jsonEncode(statisticsSnapshot.value)), category);
  }
}