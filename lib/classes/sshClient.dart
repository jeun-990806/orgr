import 'package:dartssh2/dartssh2.dart';
import 'timeParser.dart';

class AudioRequest {
  static final AudioRequest _audioRequest = AudioRequest._internal();
  static const String _SSH_HOST = '12.34.56.78';
  static const int _SSH_PORT = 9999;
  static const String _SSH_USERNAME = 'your_username';
  static const String _SSH_PASSWORD = 'your_password';
  SSHClient? client;

  /* Singleton */
  factory AudioRequest() {
    return _audioRequest;
  }
  AudioRequest._internal();

  Future<void> initSSHClient() async {
    /* SSHClient 객체를 생성한다.
     *
     * last modified: 2022-07-13
     */
    if(client == null) {
      try {
        client = SSHClient(
          await SSHSocket.connect(_SSH_HOST, _SSH_PORT),
          username: _SSH_USERNAME,
          onPasswordRequest: () => _SSH_PASSWORD,
        );
      } catch (e) {
        print('AudioRequest.initSSHClient(): SSH connection error.');
        print(e);
      }
    }
    return;
  }

  Future<SSHSession?> request(String url, int start, int end) async {
    /* 유튜브 URL, 시작 시간(초 단위), 종료 시간(초 단위)를 받아와, youtube-dl을 실행하는 SSHSession 객체를 생성히여 반환한다.
     *
     * last modified: 2022-07-13
     */

    String command = 'youtube-dl --external-downloader ffmpeg --external-downloader-args "-ss ${TimeParser.fromSeconds(start)}.00 -to ${TimeParser.fromSeconds(end)}.00" -o - -f 251 $url';
    try {
      return this.client!.execute(command);
    } catch(e) {
      print('AudioRequest.request(): cannot execute command.');
      print(e);
    }
    return null;
  }

  void disconnect(){
    this.client!.close();
  }
}