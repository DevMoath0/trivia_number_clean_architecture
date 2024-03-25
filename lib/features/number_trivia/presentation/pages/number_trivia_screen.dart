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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => serviceLocator<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: 'Start Searching!',
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Placeholder(),
                );
              },
            ),
            const SizedBox(height: 20),
            const TriviaControls()
          ],
        ),
      ),
    ),
  );
}
