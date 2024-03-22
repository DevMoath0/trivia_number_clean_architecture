import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/util/input_converter.dart';
import '../domain/entities/number_trivia.dart';
import '../domain/usecases/get_concrete_number_trivia.dart';
import '../domain/usecases/get_random_number_trivia.dart';
import 'number_trivia_event.dart';

//part 'number_trivia_event.dart';
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
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold(
            // If it was a Failure it will yield an Error
            (l) => (failure) async* {
                  yield Error(error: invalidInput);
                },
            (r) => (integer) async* {
                  // This is a [Higher order function] which takes a function as an argument
                  //
                  // or returns a function
                  yield Loading();

                  final failureOrTrivia =
                      await getConcreteNumberTrivia(Params(number: integer));

                  yield failureOrTrivia.fold(
                      (l) => Error(error: _mapFailureToMessage(l)),
                      (r) => (trivia) {
                            return Loaded(trivia: trivia);
                          });
                });
      }
    });
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
