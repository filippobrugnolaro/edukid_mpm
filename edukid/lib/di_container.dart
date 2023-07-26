import 'package:edukid/core/data/data_sources/auth_api.dart';
import 'package:edukid/core/data/data_sources/database_api.dart';
import 'package:edukid/features/authentication/data/data_sources/auth_data_source.dart';
import 'package:edukid/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/get_started/data/data_sources/get_started_data_source.dart';
import 'package:edukid/features/get_started/data/repositories/get_started_repository_impl.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';
import 'package:edukid/features/profile/data/data_sources/profile_data_source.dart';
import 'package:edukid/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:edukid/features/trivia_question/data/data_sources/trivia_data_source.dart';
import 'package:edukid/features/trivia_question/data/repositories/trivia_repository_impl.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';
import 'package:edukid/features/trivia_question/presentation/bloc/question_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Core API

  sl.registerLazySingleton<DatabaseAPI>(
          () => DatabaseAPIImpl()
  );

  sl.registerLazySingleton<AuthAPI>(
          () => AuthAPIImpl()
  );

  // Data sources

  sl.registerLazySingleton<AuthDataSource>(
          () => AuthDataSourceImpl()
  );

  sl.registerLazySingleton<TriviaDataSource>(
          () => TriviaDataSourceImpl()
  );

  sl.registerLazySingleton<ProfileDataSource>(
          () => ProfileDataSourceImpl()
  );

  sl.registerLazySingleton<GetStartedDataSource>(
          () => GetStartedDataSourceImpl()
  );

  // Repository

  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
          authDataSource: sl(),
          databaseAPI: sl()
      )
  );

  sl.registerLazySingleton<TriviaRepository>(
          () => TriviaRepositoryImpl(
          triviaDataSource: sl(),
          authAPI: sl()
      )
  );

  sl.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(
        profileDataSource: sl(),
        authAPI: sl(),
      )
  );

  sl.registerLazySingleton<GetStartedRepository>(
          () => GetStartedRepositoryImpl(
              getStartedDataSource: sl(),
              authAPI: sl(),
              databaseAPI: sl()
          )
  );

  // Bloc
  sl.registerFactory(
          () => TriviaBloc(
              triviaRepository: sl()
          )
  );

  sl.registerFactory(
          () => AuthBloc(
          authRepository: sl()
      )
  );

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}