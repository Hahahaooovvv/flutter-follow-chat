import 'package:flutter/material.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/wiget/chat/widgetMessageBubble.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class WidgetChatMessageItem extends StatelessWidget {
  final String avatar;
  final String ownAvatar;
  WidgetChatMessageItem({
    Key key,
    @required this.messageEntity,
    this.avatar,
    this.ownAvatar,
  }) : super(key: key);
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    bool isOwn = messageEntity.senderId == ReduxUtil.store.state.memberInfo.memberId;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        WidgetAvatar(url: isOwn ? avatar : ownAvatar, size: 50),
        WidgetMessageBubble(
          direction: isOwn ? WidgetMessageBubbleDirectionArrowType.right : WidgetMessageBubbleDirectionArrowType.left,
          child: Text(
            this.messageEntity.msg+" ${this.messageEntity.status}",
            textAlign: TextAlign.left,
          ),
        ),
        Container(width: 50),
      ],
    ).paddingExtension(EdgeInsets.fromLTRB(16, 16, 16, 0));
  }
}
