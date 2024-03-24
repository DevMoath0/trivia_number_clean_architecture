part of 'number_trivia_bloc.dart';

//import 'package:equatable/equatable.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

// There is two events that will happen in the app
//
// Getting the Concrete Number
// And getting the Random Number
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumber(this.numberString);

  @override
  // TODO: implement props
  List<Object?> get props {
    return [numberString];
  }
}

class GetTrivialForRandomNumber extends NumberTriviaEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
