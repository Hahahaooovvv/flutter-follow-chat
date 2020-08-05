import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';

class WidgetChatInputPage extends StatefulWidget {
  WidgetChatInputPage({Key key, this.onSend}) : super(key: key);

  final Function(int msgType, String msg) onSend;

  @override
  _WidgetChatInputPageState createState() => _WidgetChatInputPageState();
}

class _WidgetChatInputPageState extends State<WidgetChatInputPage> with SingleTickerProviderStateMixin {
  String messageValue = "";
  TextEditingController _textEditingController = TextEditingController();

  void onSend(int msgType, String msg) {
    this.widget.onSend(msgType, msg);
    this._textEditingController.text = "";
    this.setState(() {
      messageValue = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.setWidth(), 12.setHeight(), 16.setWidth(), max(12.setHeight(), MediaQuery.of(context).padding.bottom)),
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
                onPressed: this.messageValue.isEmpty ? null : () => this.onSend(0, this.messageValue),
              )
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 24.setSp(),
              ).paddingExtension(EdgeInsets.fromLTRB(0, 8.setHeight(), 8.setWidth(), 8.setHeight())).tapExtension(() async {
                String imgUrl = await ImageUtil().uploadImg(context);
                if (imgUrl != null) {
                  this.widget.onSend(1, imgUrl);
                }
              }),
            ],
          )
        ],
      ),
    );
  }
}
