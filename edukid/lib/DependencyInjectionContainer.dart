import 'package:edukid/features/trivia/data/datasources/RandomTriviaDataSource.dart';
import 'package:http/http.dart' as http;
import 'package:edukid/features/trivia/data/repositories/RandomTriviaRepositoryImpl.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';
import 'package:edukid/features/trivia/domain/usecases/GetRandomTriviaUseCase.dart';
import 'package:edukid/features/trivia/presentation/bloc/RandomTriviaBloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Bloc
  sl.registerFactory(
          () => RandomTriviaBloc(
              randomTriviaUseCase: sl()
          )
  );

  // Use cases
  sl.registerLazySingleton(
          () => GetRandomTriviaUseCase(
              sl()
          )
  );

  // Repository
  sl.registerLazySingleton<RandomTriviaRepository>(
          () => RandomTriviaRepositoryImpl(
              remoteDataSource: sl()
          )
  );

  // Data sources
  sl.registerLazySingleton<RandomTriviaRemoteDataSource>(
          () => RandomTriviaRemoteDataSourceImpl(
              client: sl()
          )
  );

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}