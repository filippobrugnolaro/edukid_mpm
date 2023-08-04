import 'package:edukid/features/statistics/domain/entities/personal_category_statistics.dart';

class PersonalCategoryStatisticsModel extends PersonalCategoryStatistics {
  PersonalCategoryStatisticsModel({int currentCorrect = 0, int currentDone = 0, int latestCorrect = 0,
    int latestDone = 0})
      : super(currentCorrect: currentCorrect, currentDone: currentDone, latestCorrect: latestCorrect, latestDone: latestDone);
  factory PersonalCategoryStatisticsModel.fromJson(Map<String, dynamic> json, String category) {
    return PersonalCategoryStatisticsModel(
        currentCorrect: json[category]['current']['correct'],
        currentDone: json[category]['current']['done'],
        latestCorrect: json[category]['latest']['correct'],
        latestDone: json[category]['latest']['done']
    );
  }
}
