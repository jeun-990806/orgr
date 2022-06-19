import 'byteSources.dart';

class Music {
  String _title;
  String _artist;
  int _duration;
  BytesSource _audioData;

  Music(String title, String artist, int duration, BytesSource audioData)
    : this._title = title,
      this._artist = artist,
      this._duration = duration,
      this._audioData = audioData;

  String getTitle(){
    return this._title;
  }

  String getArtist(){
    return this._artist;
  }

  int getDuration(){
    return this._duration;
  }

  BytesSource getAudioData(){
    return this._audioData;
  }
}