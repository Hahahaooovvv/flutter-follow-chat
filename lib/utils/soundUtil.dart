import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:path_provider/path_provider.dart';

class SoundUtil {
  String path;
  FlutterAudioRecorder recorderInstance;

  StreamController<Recording> _recorderController;
  Stream<Recording> get onProgress => (_recorderController != null) ? _recorderController.stream : null;
  Timer _timer;

  /// 请求权限
  Future<bool> requestPermissions() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    return hasPermission;
  }

  startRecord() async {
    if (await this.requestPermissions()) {
      this.path = '${(await getTemporaryDirectory()).path}/${CommonUtil.randomString()}.aac';
      this.recorderInstance = new FlutterAudioRecorder(this.path, audioFormat: AudioFormat.AAC); // .wav .aac .m4a
      await this.recorderInstance.initialized;
      await this.recorderInstance.start();
      this._recorderController = new StreamController<Recording>();
      _timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) async {
        var recording = await this.recorderInstance.current(channel: 0);
        if (!this._recorderController.isClosed && !this._recorderController.isPaused) {
          this._recorderController.sink.add(recording);
        }
      });
    } else {
      // 如果没有权限
    }
  }

  Future<Recording> endRecord() async {
    var result = await this.recorderInstance.stop();
    _timer.cancel();
    await _recorderController.close();
    print("录音已结束:");
    print(result.path);
    return result;
    // RequestHelper.fileUpLoad(
    //   fileType: 1,
    //   mltipartFile: MultipartFile.fromFileSync(this.path),
    // ).then((value) => print(value.data.success));
  }

  startPalyer([String path]) async {
    path ??= this.path;
    AudioPlayer audioPlayer = AudioPlayer();
    print(await audioPlayer.play(path, isLocal: audioPlayer.isLocalUrl(path)));
    audioPlayer.onPlayerCompletion.listen((event) {
      print("播放结束");
    });
  }
}
