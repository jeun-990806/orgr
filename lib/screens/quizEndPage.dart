import 'package:flutter/material.dart';

class QuizEndPage extends StatelessWidget {
  QuizEndPage({required this.result}) : super();

  final result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('total score: $result'),
      ),
    );
  }
}