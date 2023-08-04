import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/network/network_info.dart';
import 'package:edukid/features/statistics/data/data_sources/personal_category_statistics_data_source.dart';
import 'package:edukid/features/statistics/domain/entities/personal_category_statistics.dart';
import 'package:edukid/features/statistics/domain/repositories/personal_category_statistics_repository.dart';

class PersonalCategoryStatisticsRepositoryImpl implements PersonalCategoryStatisticsRepository {
  final PersonalCategoryStatisticsDataSource personalCategoryStatisticsDataSource;
  final AuthAPI authAPI;
  final NetworkInfo networkInfo;

  PersonalCategoryStatisticsRepositoryImpl(
      {required this.personalCategoryStatisticsDataSource, required this.authAPI, required this.networkInfo});

  @override
  Future<PersonalCategoryStatistics> getStatisticsByCategory(String category) async {
    return await personalCategoryStatisticsDataSource.getStatisticsByCategory(authAPI.getSignedInUserUID(), category);
  }

  @override
  Future<List<PersonalCategoryStatistics>> getListStatistics() async {
    List<PersonalCategoryStatistics> list = [];
    list.add(await getStatisticsByCategory('Mathematics'));
    list.add(await getStatisticsByCategory('Geography'));
    list.add(await getStatisticsByCategory('History'));
    list.add(await getStatisticsByCategory('Science'));
    return list;
  }

  @override
  Future<bool> isDeviceConnected() async {
    return await networkInfo.isConnected;
  }

}