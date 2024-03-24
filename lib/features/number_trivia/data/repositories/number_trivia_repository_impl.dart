import 'package:dartz/dartz.dart';
import 'package:trivia_clean_architicture/core/error/exceptions.dart';
import 'package:trivia_clean_architicture/core/error/failures.dart';
import 'package:trivia_clean_architicture/core/network/network_info.dart';
import 'package:trivia_clean_architicture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_clean_architicture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_clean_architicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

// typedef works just like "as" where naming something here is an example:
// List<int> IntLst => so I could use IntLst instead writing List<int> for the hole class.
typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  late final NumberTriviaRemoteDataSource remoteDataSource;
  late final NumberTriviaLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  /// To solve the redundant code I implemented this
  /// it accept a function in the parameter which is the only thing
  /// changes in this code.
  ///
  /// Which is [getConcreteOrRandom].
  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
