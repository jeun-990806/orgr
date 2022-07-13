import 'package:dartssh2/dartssh2.dart';
import 'package:orgr/classes/sshClient.dart';
import 'byteSources.dart';

class Music {
  String _title = '';
  String _artist = '';
  int _duration = 0;
  String _url = '';
  Future<SSHSession?>? _bytePipe;
  StreamSource? _audioData;

  Music(String title, String artist, int duration, String url) {
    _title = title;
    _artist = artist;
    _duration = duration;
    _url = url;
    _bytePipe = AudioRequest().request(url, duration, duration + 20);
  }

  void closeSession() async {
    /* 현재 세션을 종료한다.
     *
     * last modified: 2022-07-13
     */
    await (await this._bytePipe)!.done;
    (await this._bytePipe)!.close();
  }

  void resetSession() async {
    /* 현재 세션이 열린 경우 종료하고, 새 새션을 실행한다.
     * 비동기적으로 동작하며, 새 세션 실행 후 이전에 열렸던 세션을 종료한다.
     *
     * last modified: 2022-07-13
     */
    var prevPipe = this._bytePipe;
    this._bytePipe = AudioRequest().request(this._url, this._duration, this._duration + 20);
    if(prevPipe != null){
      await (await Future.wait([prevPipe]))[0]!.done;
      (await prevPipe)!.close();
    }
  }

  Future<void> getStream() async {
    /* 세션의 stdout 스트림으로부터 StreamSource 객체를 생성한다.
     * (StreamSource 객체는 just_audio 라이브러리의 StreamAudioSource 클래스를 상속받아 작성한 것이다.)
     *
     * last modified: 2022-07-13
     */
    var pipe = await _bytePipe;

    try {
      _audioData = StreamSource(pipe!.stdout);
    } catch (e) {
      print(e);
    }
  }

  String getTitle(){
    return this._title;
  }

  String getArtist(){
    return this._artist;
  }

  int getDuration(){
    return this._duration;
  }

  StreamSource? getAudioData(){
    return this._audioData;
  }
}