import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/wiget/chat/widgetMessageBubble.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class WidgetChatMessageItem extends StatelessWidget {
  WidgetChatMessageItem({Key key, this.isOwn: false}) : super(key: key);
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        WidgetAvatar(url: null, size: 50),
        Container(
          alignment: Alignment.centerLeft,
          child: WidgetMessageBubble(
            direction: isOwn ? WidgetMessageBubbleDirectionArrowType.right : WidgetMessageBubbleDirectionArrowType.left,
            child: Text("lk富士康酒副科级阿森纳打开肌肤"),
          ),
        ).flexExtension(),
        Container(width: 50),
      ],
    ).paddingExtension(EdgeInsets.fromLTRB(16, 16, 16, 0));
  }
}
