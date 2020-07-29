import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/wiget/chat/widgetMessageBubble.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class WidgetChatMessageItem extends StatelessWidget {
  final String avatar;
  final String ownAvatar;
  final String beforeTime;
  WidgetChatMessageItem({
    Key key,
    @required this.messageEntity,
    this.avatar,
    this.ownAvatar,
    this.beforeTime,
  }) : super(key: key);
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    bool isOwn = messageEntity.senderId == ReduxUtil.store.state.memberInfo.memberId;
    bool showTime = true;
    if (beforeTime != null) {
      showTime = DateTime.parse(this.beforeTime).add(Duration(minutes: 4)).isBefore(DateTime.parse(this.messageEntity.senderTime));
    }
    return Column(
      children: [
        if (showTime) WidgetChatMessageTip(dateTime: this.messageEntity.senderTime),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
          children: <Widget>[
            WidgetAvatar(url: !isOwn ? avatar : ownAvatar, size: 40),
            WidgetMessageBubble(
              direction: isOwn ? WidgetMessageBubbleDirectionArrowType.right : WidgetMessageBubbleDirectionArrowType.left,
              child: Text(
                this.messageEntity.msg,
                textAlign: TextAlign.left,
              ),
            ),
            Container(width: 50),
          ],
        ).paddingExtension(EdgeInsets.fromLTRB(16, 16, 16, 0))
      ],
    ).paddingExtension(EdgeInsets.symmetric(vertical: 2.setHeight()));
  }
}

class WidgetChatMessageTip extends StatelessWidget {
  final String dateTime;

  const WidgetChatMessageTip({Key key, this.dateTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.setHeight()),
      child: Text(DateUtil.formatDateStr(dateTime, format: "MM-dd HH:mm"), style: TextStyle(color: Colors.white, fontSize: 12.setSp())),
      padding: EdgeInsets.symmetric(horizontal: 8.setWidth(), vertical: 2.setHeight()),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(140),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
