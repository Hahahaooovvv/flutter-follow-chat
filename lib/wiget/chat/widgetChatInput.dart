import 'dart:io';
import 'package:flutter/material.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/wiget/chat/widgetChatAudioRecordBtn.dart';

class WidgetChatInputPage extends StatefulWidget {
  WidgetChatInputPage({Key key, this.onSend, this.scrollToEnd}) : super(key: key);

  final Function(EntityChatMessage chatMessage) onSend;
  final Function scrollToEnd;

  @override
  _WidgetChatInputPageState createState() => _WidgetChatInputPageState();
}

class _WidgetChatInputPageState extends State<WidgetChatInputPage> with SingleTickerProviderStateMixin {
  String messageValue = "";
  TextEditingController _textEditingController = TextEditingController();
  bool showSound = false;
  void onSend(EntityChatMessage chatMessage) {
    this.widget.onSend(chatMessage);
    this._textEditingController.text = "";
    this.setState(() {
      messageValue = "";
    });
  }

  void sendImg() async {
    // 发送图片
    File _file = await ImageUtil().getImg();
    if (_file != null) {
      var _size = await ImageUtil().getImageSize(_file);
      this.widget.onSend(EntityChatMessage.formFastSend(setMsg: _file.path, setSessionId: null, setMsgType: 1)
        ..extend = EntityChatMessageExtend(
          size: Size(200, _size.height / (_size.width / 200)),
        ));
    }
  }

  /// 打开扩展面板
  openExtends() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 180.setHeight(),
            child: WidgetChatAudioRecordBtn(onSend: (entity) {
              Navigator.pop(_);
              this.onSend(entity);
            }),
          );

          // (AnimatedContainer(
          //   onEnd: this.widget.scrollToEnd,
          //   color: Theme.of(context).scaffoldBackgroundColor,
          //   duration: Duration(milliseconds: 100),
          //   height: !this.showSound ? 0 : 180.setHeight(),
          //   child: WidgetChatAudioRecordBtn(onSend: this.onSend),
          // ).tapExtension(() {
          //   this.setState(() {
          //     showSound = false;
          //   });
          // }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.setHeight(), bottom: MediaQuery.of(context).padding.bottom),
      color: Color.fromARGB(255, 247, 247, 247),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              TextField(
                controller: this._textEditingController,
                onChanged: (str) {
                  setState(() {
                    this.messageValue = str;
                  });
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 12.setSp()),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: [0, 16].setPadding(),
                ),
              ).paddingExtension(EdgeInsets.only(right: 16.setWidth())).flexExtension(),
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.send),
                onPressed: this.messageValue.isEmpty ? null : () => this.onSend(EntityChatMessage.formFastSend(setMsg: this.messageValue, setSessionId: null, setMsgType: 0)),
              )
            ],
          ).paddingExtension(EdgeInsets.symmetric(horizontal: 16.setWidth())),
          Row(
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 24.setSp(),
              ).paddingExtension(EdgeInsets.fromLTRB(0, 8.setHeight(), 24.setWidth(), 8.setHeight())).tapExtension(this.sendImg),
              GestureDetector(
                child: Icon(
                  Icons.mic_none_outlined,
                  size: 24.setSp(),
                ),
                onTap: this.openExtends,
              ).paddingExtension(EdgeInsets.fromLTRB(0, 8.setHeight(), 8.setWidth(), 8.setHeight())),
            ],
          ).paddingExtension(EdgeInsets.symmetric(horizontal: 16.setWidth())),
        ],
      ),
    );
  }
}
