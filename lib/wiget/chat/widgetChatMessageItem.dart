import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
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
  final Function onImagePress;
  final Function onRePushMessage;
  WidgetChatMessageItem({
    Key key,
    @required this.messageEntity,
    this.avatar,
    this.ownAvatar,
    this.beforeTime,
    this.onImagePress,
    this.onRePushMessage,
  }) : super(key: key);
  final MessageEntity messageEntity;
  Widget buildMsgContext() {
    switch (this.messageEntity.msgType) {
      case 0:
        return Text(
          this.messageEntity.msg ?? "",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14.setSp()),
        );
      case 1:
        double _height = 0;
        try {
          var widthList = this.messageEntity.msg.replaceFirst(".png", "").split("_").last.split("x").map((e) => double.parse(e)).toList();
          _height = widthList[1] / (widthList[0] / 200);
        } catch (e) {}

        return CachedNetworkImage(imageUrl: this.messageEntity.msg, width: 200, height: _height).tapExtension(this.onImagePress);
      default:
        return Container();
    }
  }

  Widget buildStatus(BuildContext _context) {
    if (this.messageEntity.status == 0) {
      // 为发送成功
      // 如果时间超过了10秒钟 则发送失败 展示错误图标
      if (DateTime.parse(this.messageEntity.senderTime).add(Duration(seconds: 10)).isBefore(DateTime.now())) {
        return Icon(
          Icons.error,
          size: 24.setSp(),
          color: Theme.of(_context).errorColor,
        ).tapExtension(() {
          // 从新发送消息
          showDialog(
              context: _context,
              builder: (_context) {
                return AlertDialog(
                  content: Text("消息发送失败，是否从新发送"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(_context);
                          this.onRePushMessage(this.messageEntity);
                        },
                        child: Text("从新发送")),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(_context);
                        },
                        child: Text("取消", style: Theme.of(_context).textTheme.bodyText1)),
                  ],
                );
              });
        });
      } else {
        return CupertinoActivityIndicator();
      }
    }
    return Container();
  }

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
              child: this.buildMsgContext(),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.setHeight()),
              width: 50,
              child: this.buildStatus(context),
            ),
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
