import 'package:flutter/material.dart';
import 'classes/sshClient.dart';
import 'screens/quizIntroPage.dart';

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
      home: QuizIntroPage(),
    );
  }
}