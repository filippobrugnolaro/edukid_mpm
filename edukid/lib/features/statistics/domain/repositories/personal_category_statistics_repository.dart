import 'package:edukid/features/statistics/domain/entities/personal_category_statistics.dart';

abstract class PersonalCategoryStatisticsRepository {
  Future<PersonalCategoryStatistics> getStatisticsByCategory(String category);
  Future<List<PersonalCategoryStatistics>> getListStatistics();
}