import 'package:edukid/core/data/data_sources/auth_data_source.dart';
import 'package:edukid/core/data/data_sources/database_data_source.dart';
import 'package:edukid/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:edukid/features/trivia_question/data/repositories/trivia_repository_impl.dart';
import 'package:edukid/features/trivia_question/domain/repositories/trivia_repository.dart';
import 'package:edukid/features/trivia_question/presentation/bloc/question_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Bloc
  sl.registerFactory(
          () => TriviaBloc(
              triviaRepository: sl(),
              authRepository: sl()
          )
  );

  sl.registerFactory(
          () => AuthBloc(
          authRepository: sl()
      )
  );

  // Repository
  sl.registerLazySingleton<TriviaRepository>(
          () => TriviaRepositoryImpl(
              databaseDataSource: sl()
          )
  );

  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
              authDataSource: sl(),
              databaseDataSource: sl()
          )
  );

  sl.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(
          authDataSource: sl(),
          databaseDataSource: sl()
      )
  );

  // Data sources

  sl.registerLazySingleton<DatabaseDataSource>(
          () => DatabaseDataSourceImpl()
  );

  sl.registerLazySingleton<AuthDataSource>(
          () => AuthDataSourceImpl()
  );

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}