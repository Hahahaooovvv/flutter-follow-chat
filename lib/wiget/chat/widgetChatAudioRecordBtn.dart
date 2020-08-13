import 'dart:async';

import 'package:flutter/material.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/soundUtil.dart';

class WidgetChatAudioRecordBtn extends StatefulWidget {
  WidgetChatAudioRecordBtn({
    Key key,
    @required this.onSend,
  }) : super(key: key);
  final Function(int msgType, String msg) onSend;
  @override
  _WidgetChatAudioRecordBtnState createState() => _WidgetChatAudioRecordBtnState();
}

class _WidgetChatAudioRecordBtnState extends State<WidgetChatAudioRecordBtn> with TickerProviderStateMixin {
  AnimationController controller;
  bool soundAnimated = false;

  StreamSubscription _streamSubscription;

  Timer _timer;
  double size = 0;

  /// 音频工具
  SoundUtil soundUtil = SoundUtil();

  closeTimer() {
    if (this._timer != null) {
      this._timer.cancel();
      this._timer = null;
    }
  }

  startAnimated() async {
    if (await this.soundUtil.requestPermissions()) {
      CommonUtil.vibrate();
      this.closeTimer();
      this.setState(() {
        this.size = 130;
      });
      this._timer = Timer(Duration(milliseconds: 120), () {
        this.setState(() {
          size = 0;
          this._timer = null;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    /// 请求麦克风权限
    CommonUtil.whenRenderEnd((duration) {
      this.soundUtil.requestPermissions();
    });
  }

  void startRecord() async {
    await soundUtil.startRecord();
    _streamSubscription = soundUtil.onProgress.listen((event) {
      if (event.metering.peakPower > -22) {
        this.startAnimated();
      }
    });
    this.setState(() {
      this.soundAnimated = true;
    });
  }

  void endRecord(LongPressEndDetails e) async {
    await _streamSubscription.cancel();
    this.setState(() {
      this.soundAnimated = false;
    });
    var result = await soundUtil.endRecord();
    var timeSpan = result.duration.compareTo(Duration(seconds: 1));
    print(timeSpan);
    if (timeSpan == 1) {
      this.widget.onSend(2, result.path);
    } else {
      ModalUtil.toastMessage("录音时长过短");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: this.startRecord,
          onLongPressEnd: this.endRecord,
          onTap: () {},
          child: ClipOval(
              child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(this.soundAnimated ? 180 : 255),
            ),
            duration: Duration(milliseconds: 200),
            width: this.soundAnimated ? 130 : 100,
            height: this.soundAnimated ? 130 : 100,
            child: Icon(Icons.mic, color: Colors.white),
          )),
        ).centerExtension(),
        if (this.soundAnimated)
          GestureDetector(
            child: ClipOval(
                child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              duration: Duration(milliseconds: 100),
              width: this.size,
              height: this.size,
            )),
          ).centerExtension(),
      ],
    );
  }
}
