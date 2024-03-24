import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_clean_architicture/features/number_trivia/presentation/number_trivia_bloc.dart';
import 'package:trivia_clean_architicture/injection_container.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaScreen extends StatelessWidget {
  const NumberTriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
        ),
        body: BlocProvider(
          create: (_) => serviceLocator<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return MessageDisplay(
                          message: 'Start Searching!',
                        );
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Placeholder(),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  TriviaControls()
                ],
              ),
            ),
          ),
        ));
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchConcrete,
                child: Text('Search'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: Text('Get random Trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTrivialForRandomNumber());
  }
}
