import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_clean_architicture/core/network/network_info.dart';
import 'package:trivia_clean_architicture/core/util/input_converter.dart';
import 'package:trivia_clean_architicture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_clean_architicture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_clean_architicture/features/number_trivia/presentation/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

// Dependency injector
final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  // Bloc
  // Note: Remember whenever you do disposal logic use a Factory
  // not a Singleton to not get the same instance.
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator()),
  );

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  // Core Stuff
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
