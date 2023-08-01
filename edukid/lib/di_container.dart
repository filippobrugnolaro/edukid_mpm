import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/core/network/network_info.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_local.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source_remote.dart';
import 'package:edukid/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/get_started/data/data_sources/get_started_data_source.dart';
import 'package:edukid/features/get_started/data/repositories/get_started_repository_impl.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';
import 'package:edukid/features/profile/data/data_sources/profile_data_source.dart';
import 'package:edukid/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:edukid/features/statistics/data/data_sources/leaderboard_data_source.dart';
import 'package:edukid/features/statistics/data/data_sources/personal_category_statistics_data_source.dart';
import 'package:edukid/features/statistics/data/repositories/leaderboard_repository_impl.dart';
import 'package:edukid/features/statistics/domain/repositories/leaderboard_repository.dart';
import 'package:edukid/features/statistics/domain/repositories/personal_category_statistics_repository.dart';
import 'package:edukid/features/trivia_question/data/data_sources/trivia_data_source.dart';
import 'package:edukid/features/trivia_question/data/repositories/trivia_repository_impl.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';
import 'package:edukid/features/trivia_question/presentation/bloc/question_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/statistics/data/repositories/personal_category_statistics_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core API

  sl.registerLazySingleton<DatabaseAPI>(() => DatabaseAPIImpl());

  sl.registerLazySingleton<AuthAPI>(() => AuthAPIImpl());

  // Data sources

  sl.registerLazySingleton<AuthDataSourceRemote>(() => AuthDataSourceRemoteImpl());
  
  sl.registerLazySingleton<AuthDataSourceLocal>(() => AuthDataSourceLocalImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<TriviaDataSource>(() => TriviaDataSourceImpl());

  sl.registerLazySingleton<ProfileDataSource>(() => ProfileDataSourceImpl());

  sl.registerLazySingleton<GetStartedDataSource>(
      () => GetStartedDataSourceImpl());

  sl.registerLazySingleton<LeaderboardDataSource>(
      () => LeaderboardDataSourceImpl());

  sl.registerLazySingleton<PersonalCategoryStatisticsDataSource>(
          () => PersonalCategoryStatisticsDataSourceImpl());

  // Repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authDataSourceRemote: sl(), authDataSourceLocal: sl(), databaseAPI: sl()));

  sl.registerLazySingleton<TriviaRepository>(() => TriviaRepositoryImpl(
      triviaDataSource: sl(), authAPI: sl(), databaseAPI: sl()));

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        profileDataSource: sl(),
        authAPI: sl(),
      ));

  sl.registerLazySingleton<GetStartedRepository>(() => GetStartedRepositoryImpl(
      getStartedDataSource: sl(), authAPI: sl(), databaseAPI: sl()));

  sl.registerLazySingleton<LeaderboardRepository>(() =>
      LeaderboardRepositoryImpl(leaderboardDataSource: sl(), authAPI: sl()));

  sl.registerLazySingleton<PersonalCategoryStatisticsRepository>(() =>
      PersonalCategoryStatisticsRepositoryImpl(personalCategoryStatisticsDataSource: sl(), authAPI: sl()));

  // Bloc
  sl.registerFactory(() => TriviaBloc(triviaRepository: sl()));

  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Network Checker
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
