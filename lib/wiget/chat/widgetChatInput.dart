import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

class WidgetChatInputPage extends StatefulWidget {
  WidgetChatInputPage({Key key, this.onSend}) : super(key: key);

  final Function(String msg) onSend;

  @override
  _WidgetChatInputPageState createState() => _WidgetChatInputPageState();
}

class _WidgetChatInputPageState extends State<WidgetChatInputPage> with SingleTickerProviderStateMixin {
  String messageValue = "";
  TextEditingController _textEditingController = TextEditingController();

  void onSend() {
    this.widget.onSend(this.messageValue);
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
      child: Row(
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
            onPressed: this.messageValue.isEmpty ? null : this.onSend,
          )
        ],
      ),
    );
  }
}
