import 'package:just_audio/just_audio.dart';

class StreamSource extends StreamAudioSource {
  final Stream<List<int>> _audioStream;
  int? _length;

  StreamSource(this._audioStream, [this._length]) : super(tag: '');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
      sourceLength: _length,
      contentLength: _length,
      offset: 0,
      stream: this._audioStream,
      contentType: 'audio/raw'
    );
  }
}