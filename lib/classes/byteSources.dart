import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

class BytesSource extends StreamAudioSource {
  final Uint8List _buffer;

  BytesSource(this._buffer) : super(tag: '');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: _buffer.length,
        offset: start ?? 0,
        stream: Stream.fromIterable([_buffer.sublist(start ?? 0, end)]),
        contentType: 'audio/raw'
    );
  }
}