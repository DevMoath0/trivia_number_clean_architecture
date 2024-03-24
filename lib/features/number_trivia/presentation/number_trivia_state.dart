part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => throw UnimplementedError('Loading');
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded({required this.trivia});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      trivia,
    ];
  }
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      message,
    ];
  }
}
