import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/soundUtil.dart';

class WidgetChatAudioRecordBtn extends StatefulWidget {
  WidgetChatAudioRecordBtn({
    Key key,
    @required this.onSend,
  }) : super(key: key);
  final Function(EntityChatMessage chatMessage) onSend;
  @override
  _WidgetChatAudioRecordBtnState createState() => _WidgetChatAudioRecordBtnState();
}

class _WidgetChatAudioRecordBtnState extends State<WidgetChatAudioRecordBtn> with TickerProviderStateMixin {
  AnimationController controller;
  bool soundAnimated = false;

  int _times = 0;

  Timer _timer;

  Stream _stream;

  double size = 0;
  bool recording = false;

  /// 音频工具
  SoundUtil soundUtil = SoundUtil();

  @override
  void initState() {
    super.initState();

    /// 请求麦克风权限
    CommonUtil.whenRenderEnd((duration) {
      this.soundUtil.requestPermissions();
    });
  }

  void startRecord() async {
    CommonUtil.vibrate();
    await soundUtil.startRecord();
    this.recording = true;
    this._stream = soundUtil.onProgress;
    this.setState(() {
      this.soundAnimated = true;
      this._times = 0;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        this._times += 1000;
      });
      if (Duration(milliseconds: this._times).compareTo(Duration(minutes: 5)) == 1) {
        this.endRecord();
        ModalUtil.toastMessage("单次录音时长不能超过5分钟");
        return;
      }
    });
  }

  void endRecord([LongPressEndDetails e]) async {
    if (this.recording = true) {
      this.recording = false;
      this.setState(() {
        this.soundAnimated = false;
      });
      this._stream = null;
      _timer?.cancel();
      _timer = null;
      var result = await soundUtil.endRecord();
      print(result.path);
      var timeSpan = result.duration.compareTo(Duration(milliseconds: 500));
      if (timeSpan == 1) {
        this.widget.onSend(EntityChatMessage.formFastSend(setMsg: result.path, setSessionId: null, setMsgType: 2)..extend = EntityChatMessageExtend(duration: this._times));
      } else {
        ModalUtil.toastMessage("录音时长过短");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 16.setHeight()),
        if (this.soundAnimated == true)
          StreamBuilder<Recording>(
            stream: this._stream,
            builder: (context, data) {
              double power = (data.data?.metering?.averagePower ?? 50).abs() / 10;
              print(power);
              List<Widget> grid = List<Widget>.generate(5, (index) {
                int _index = 5 - index;
                return Container(
                  margin: EdgeInsets.only(right: 2.setWidth()),
                  width: 4.setWidth(),
                  height: 12.setHeight(),
                  decoration: BoxDecoration(
                    color: _index - power < 0 ? Colors.white : Colors.grey[350],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              });
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisSize: MainAxisSize.min,
                    children: grid,
                  ),
                  Text(DateUtil.formatDateMs(_times, format: "mm:ss"), style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp())))
                      .paddingExtension(EdgeInsets.symmetric(vertical: 4.setHeight(), horizontal: 8.setWidth())),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: grid,
                  ),
                ],
              ).sizeExtension(height: 24.setHeight());
            },
          ),
        if (this.soundAnimated != true)
          Text('长按说话', style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp())))
              .paddingExtension(EdgeInsets.symmetric(vertical: 4.setSp()))
              .sizeExtension(height: 24.setHeight()),
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
            width: 100.setWidth(),
            height: 100.setWidth(),
            child: Icon(Icons.mic, color: Colors.white),
          )),
        ).centerExtension().flexExtension()
      ],
    );
  }
}
