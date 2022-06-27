import 'package:flutter/material.dart';
import 'quizPage.dart';

class QuizIntroPage extends StatelessWidget {
  QuizIntroPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              child: const Text('Start!'),
            ),
          ]
        )
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => QuizPage(title: 'ORGR Quiz!'),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}