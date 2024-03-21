import 'package:dartz/dartz.dart';
import 'package:trivia_clean_architicture/core/usecases/usecase.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams {}
