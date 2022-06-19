import 'package:flutter/material.dart';
import 'screens/quizPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORGR Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(title: 'ORGR Demo'),
    );
  }
}