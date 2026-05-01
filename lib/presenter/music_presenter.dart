import 'package:audioplayers/audioplayers.dart';

class MusicPresenter {
  static final MusicPresenter _instance = MusicPresenter._internal();
  factory MusicPresenter() => _instance;

  MusicPresenter._internal();

  final AudioPlayer _player = AudioPlayer();

  double volume = 1.0;

  Future<void> play(String url) async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> setVolume(double v) async {
    volume = v;
    await _player.setVolume(v);
  }
}