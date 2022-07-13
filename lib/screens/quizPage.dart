import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'quizEndPage.dart';

import '../classes/music.dart';
import '../classes/question.dart';
import '../classes/sshClient.dart';


class QuizPage extends StatefulWidget {
  QuizPage({required this.title}) : super();

  final String title;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _player = AudioPlayer();

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
    await AudioRequest().initSSHClient();
    try {
      /* EDM Hits Playlist */
      _audioData = [
        new Music('Diamonds', 'Timmy Trumpet', 20, 'https://www.youtube.com/watch?v=vLadkYLi8YE'),
        new Music('Pure Grinding', 'Avicii', 30, 'https://www.youtube.com/watch?v=a8UJHVd10Jw'),
        new Music('City Lights', 'Avicii', 11, 'https://www.youtube.com/watch?v=R43PCsV92R4'),
        new Music('Follow', 'Martin Garrix & Zedd', 34, 'https://www.youtube.com/watch?v=SpIgOm5vFkE'),
        new Music('Find You', 'Martin Garrix & Justin Mylo', 55, 'https://www.youtube.com/watch?v=gtzssOjihIU'),
        new Music('My Feelings For You', 'Avicii', 12, 'https://www.youtube.com/watch?v=F4v3ltB7jxs'),
        new Music('The Drop', 'David Guetta & Dimitri Vegas', 34, 'https://www.youtube.com/watch?v=NvPm_7WeuVQ'),
        new Music('Hot In It', 'Tiësto, Charli XCX', 22, 'https://www.youtube.com/watch?v=TBDGLLgLZqI'),
        new Music('These Nights', 'Loud Luxury', 54, 'https://www.youtube.com/watch?v=Uhz6fXjc9IQ'),
      ];
      _audioData.shuffle();
      /* Asynchronous Execution */
      _audioData.map((e) => {e.getStream()});
      /* Music.getStream()은 "비동기적으로" SSH 서버에 연결하여 새 세션을 만들고, 세션의 stdout 스트림을 자신의 _audioData 객체에 저장한다.
       * 게임이 시작하기 전 출제될 모든 Music 객체가 비동기적으로 세션을 생성하고 스트림을 저장하면 순차적으로 수행할 때보다 로딩을 줄일 수 있을 것이다.
       * (사용자가 퀴즈를 푸는 시간을 로딩에 활용할 수 있으므로)
       */

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
    try {
      await _audioData[_currentAudioIndex].getStream();
      await _player.setAudioSource(
          _audioData[_currentAudioIndex].getAudioData()!);
    } catch(e) {
      /* 원인 불명 에러로 인해, 가끔 재생이 안 될 때가 있다.
       * 그럴 때 재시도를 수행하면 정상적으로 재생이 된다.
       */
      _audioData[_currentAudioIndex].resetSession();
      await _audioData[_currentAudioIndex].getStream();
      await _player.setAudioSource(
          _audioData[_currentAudioIndex].getAudioData()!);
    }
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
    this._player.dispose();
    this._audioData.map((e) => {e.closeSession()});
    /* 종료 시 생성된 모든 세션을 종료한다. */
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

  Container customButton({onPressed, text}){
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -5,
            blurRadius: 4,
            offset: Offset(0, 5),)
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.black12),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black54
          ),
        ),
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
                    customButton(
                        text: this._answers[k],
                        onPressed: () {
                          var result = _checkAnswer(this._answers[k]);
                          var overlay = _makeOverlayEntry(result);
                          Overlay.of(context)!.insert(overlay);
                          Timer(Duration(seconds: 3), () {
                            overlay.remove();
                            if(this._currentAudioIndex == this._audioData.length - 1){
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizEndPage(result: score)));
                            }else {
                              _next();
                            }
                          });
                        }
                    )
                ]
            )
        )
    );
  }
}
