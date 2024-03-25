import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/util/input_converter.dart';
import '../domain/entities/number_trivia.dart';
import '../domain/usecases/get_concrete_number_trivia.dart';
import '../domain/usecases/get_random_number_trivia.dart';
//import 'number_trivia_event.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInput =
    'Invalid Input - The number must be positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getConcreteNumberTriviaHandler);
    on<GetTriviaForRandomNumber>(_getRandomNumberTriviaHandler);
  }

  // For the ConcreteNumberTrivia
  Future<void> _getConcreteNumberTriviaHandler(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emitter,
  ) async {
    final result =
        inputConverter.stringToUnsignedInteger.call(event.numberString);

    result.fold(
      (failure) {
        emit(Error(message: invalidInput));
      },
      (number) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: number));

        failureOrTrivia.fold(
          (failure) {
            emit(Error(message: _mapFailureToMessage(failure)));
          },
          (number) {
            emit(Loaded(trivia: number));
          },
        );
      },
    );
  }

  // For the RandomNumberTrivia
  Future<void> _getRandomNumberTriviaHandler(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    failureOrTrivia.fold(
      (failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      },
      (number) {
        emit(Loaded(trivia: number));
      },
    );
  }

  // Instead of using ternary operator to decide which failure message to provide.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case serverFailureMessage:
        return serverFailureMessage;
      case cacheFailureMessage:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
