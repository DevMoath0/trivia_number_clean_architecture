import 'package:trivia_clean_architicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({required super.text, required super.number});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      //I cast it to num since it could be a double and corrupt the
      //response from the json so I put it as num
      //then cast it to Int.
      number: (json['number'] as num).toInt(),
    );
  }
}
