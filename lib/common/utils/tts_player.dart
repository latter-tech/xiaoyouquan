import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';

class TtsPlayer {

  factory TtsPlayer() => _instance;

  static final TtsPlayer _instance = TtsPlayer._internal();

  TtsPlayer._internal() {
    _initializeTts();
  }

  late final FlutterTts _flutterTts;

  Future<void> _initializeTts() async {
    print("initialize TTS + xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  /// 播放文本
  Future<void> speak(String? text) async {
    if( text == null || text.isEmpty ) {
      return;
    }
    await _flutterTts.speak(text);
  }

  /// 停止播放
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// 设置播放完成回调
  void setCompletionHandler(VoidCallback callback) {
    _flutterTts.setCompletionHandler(callback);
  }

  /// 设置取消回调
  void setCancelHandler(VoidCallback callback) {
    _flutterTts.setCancelHandler(callback);
  }

}