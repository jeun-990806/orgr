import 'dart:math';
import '../samples/metadata.dart';

class Question {
  List<String> _choiceOptions = [];
  int _optionLength = -1;
  int _answerIndex = -1;

  Question(String answer, int length) {
    this._optionLength = length;
    this._createOptions(answer);
  }

  void _createOptions(String answer){
    Random random = Random();
    String artist, title;

    while(this._choiceOptions.length != _optionLength - 1){
      artist = MUSICS.keys.elementAt(random.nextInt(MUSICS.keys.length));
      title = MUSICS[artist]![random.nextInt(MUSICS[artist]!.length)];
      if(title != answer && this._choiceOptions.indexOf(title) == -1) this._choiceOptions.add(title);
    }

    this._choiceOptions.add(answer);
    this._choiceOptions.shuffle();
    this._answerIndex = this._choiceOptions.indexOf(answer);
  }

  List<String> getOptions(){
    return this._choiceOptions;
  }

  bool checkAnswer(String answer){
    if(this._choiceOptions.indexOf(answer) == this._answerIndex) return true;
    else return false;
  }
}