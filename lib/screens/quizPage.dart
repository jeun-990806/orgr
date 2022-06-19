import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

import '../classes/byteSources.dart';
import '../classes/music.dart';
import '../classes/question.dart';

import 'dart:math';
import 'dart:io';

class QuizPage extends StatefulWidget {
  QuizPage({required this.title}) : super();

  final String title;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _player = AudioPlayer();
  final _random = Random();

  List<Music> _audioData = [];
  int _currentAudioIndex = 0;
  List<String> _answers = ['', '', '', ''];
  var _quizCreator;
  String _message = '';

  @override
  void initState(){
    super.initState();
    _setAudioData();
  }

  Future<void> _setAudioData() async {
    try {
      _audioData = [
        new Music('美しい', 'Tempalay', 280, BytesSource(await rootBundle.load('assets/media/01.mp3').then((value) => value.buffer.asUint8List()))),
        new Music('SONIC WAVE', 'Tempalay', 280, BytesSource(await rootBundle.load('assets/media/02.m4a').then((value) => value.buffer.asUint8List()))),
        new Music('新世代', 'Tempalay', 210, BytesSource(await rootBundle.load('assets/media/03.webm').then((value) => value.buffer.asUint8List()))),
        new Music('LAST DANCE', 'Tempalay', 189, BytesSource(await rootBundle.load('assets/media/04.webm').then((value) => value.buffer.asUint8List()))),
      ];
      _audioData.shuffle();
      _next();
    } catch (e) {
      print("Error loading audio source: $e");
      _message = 'error loading audio source';
    }
  }

  void _next() {
    sleep(Duration(milliseconds: 100));
    setState(() {
      _currentAudioIndex++;
      if(_currentAudioIndex >= this._audioData.length) _currentAudioIndex = 0;
      _setAnswers();
    });
    _play();
  }

  Future<void> _play() async {
    _player.stop();
    await _player.setAudioSource(_audioData[_currentAudioIndex].getAudioData());
    await _player.seek(Duration(seconds: 15 + _random.nextInt(30)));
    _player.play();
  }

  void _setAnswers() {
    _quizCreator = Question(_audioData[_currentAudioIndex].getTitle(), 4);
    _answers = _quizCreator.getOptions();
  }

  void _checkAnswer(String answer){
    setState(() {
      if(_quizCreator.checkAnswer(answer)) _message = 'Right!';
      else _message = 'Wrong...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for(var k=0; k<this._answers.length; k++)
                    OutlinedButton(
                        onPressed: () {
                          _checkAnswer(this._answers[k]);
                          _next();
                        },
                        child: Text(this._answers[k])
                    ),
                  Text(_message)
                ]
            )
        )
    );
  }
}
