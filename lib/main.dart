import 'package:flutter/material.dart';
import 'package:trivia_clean_architicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_architicture/features/number_trivia/presentation/pages/number_trivia_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  // Needs to initiate the [Dependency Injection] before the app start
  // To make every single dependency registered before the UI
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia',
      home: NumberTriviaScreen(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple.shade500,
      ),
    );
  }
}
