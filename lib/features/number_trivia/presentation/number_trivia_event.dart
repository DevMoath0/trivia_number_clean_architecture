part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class getTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  getTriviaForConcreteNumber(this.numberString);

  @override
  // TODO: implement props
  List<Object?> get props {
    return [numberString];
  }
}

class getTrivialForRandomNumber extends NumberTriviaEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
