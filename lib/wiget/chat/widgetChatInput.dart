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

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 100.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    // controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, max(12, MediaQuery.of(context).padding.bottom)),
      color: Color.fromARGB(255, 247, 247, 247),
      child: Row(
        children: <Widget>[
          TextField(
            onChanged: (str) {
              if (str.isNotEmpty) {
                controller.forward();
              } else {
                controller.reverse();
              }
              setState(() {
                this.messageValue = str;
              });
            },
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: InputBorder.none),
          ).flexExtension(),
          Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            height: 48,
            child: this.messageValue.isNotEmpty
                ? Text(
                    "发送",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                : Container(), // WidgetIcon("icon_appbar_add", size: 50),
            width: animation.value,
          ).paddingExtension(EdgeInsets.only(left: this.messageValue.isNotEmpty ? 0 : 16)).tapExtension(() {
            this.widget.onSend(this.messageValue);
          })
        ],
      ),
    );
  }
}
