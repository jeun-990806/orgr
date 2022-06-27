import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

import 'quizEndPage.dart';

import '../classes/byteSources.dart';
import '../classes/music.dart';
import '../classes/question.dart';

import 'dart:math';

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

  int score = 0;

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
      setState(() { _setAnswers(); });
      _play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void _next() {
    setState(() {
      _currentAudioIndex++;
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

  bool _checkAnswer(String answer){
    var result = _quizCreator.checkAnswer(answer);
    if(result) score += 10;
    return result;
  }

  @override
  void dispose(){
    //this._player.stop();
    super.dispose();
  }

  OverlayEntry _makeOverlayEntry(var isRight){
    return OverlayEntry(
      builder: (context) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.4)
                ),
              ),
            ),
            if(isRight)
              Image.asset(
                'assets/images/right.png',
                width: 200,
                height: 150,
                fit: BoxFit.fill,
              )
            else
              Image.asset(
                  'assets/images/wrong.png',
                  width: 200,
                  height: 150,
                  fit: BoxFit.fill
              )
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: Text(
                      '노래 제목 맞히기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  for(var k=0; k<this._answers.length; k++)
                    SizedBox(
                      width: double.infinity,
                      child:
                        OutlinedButton(
                          onPressed: () {
                            var result = _checkAnswer(this._answers[k]);
                            var overlay = _makeOverlayEntry(result);
                            Overlay.of(context)!.insert(overlay);
                            Timer(Duration(seconds: 3), () {
                              overlay.remove();
                              if(this._currentAudioIndex == this._answers.length - 1){
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizEndPage(result: score)));
                              }else {
                                _next();
                              }
                            });
                          },
                          child: Text(this._answers[k]),
                        ),
                    )
                ]
            )
        )
    );
  }
}
