import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/wiget/chat/widgetChatInput.dart';
import 'package:follow/wiget/chat/widgetChatMessageItem.dart';

class ChatRoomCommonPage extends StatefulWidget {
  /// 对象ID 如果为群 对象就为群
  final String sessionId;

  /// 0单聊 1群聊
  final int isGroup;
  ChatRoomCommonPage({
    Key key,
    @required this.sessionId,
    @required this.isGroup,
  }) : super(key: key);

  @override
  _ChatRoomCommonPageState createState() => _ChatRoomCommonPageState();
}

class _ChatRoomCommonPageState extends State<ChatRoomCommonPage> {
  @override
  void initState() {
    super.initState();
  }

  void onSend(String message) {
    var temple = EntityNoticeTemple(
      type: 1,
      senderId: ReduxUtil.store.state.memberInfo.memberId,
      receiveId: "12321",
      content: json.encode({"msg": message,"msgType":0}),
      createTime: DateTime.now().toIso8601String(),
      isRead: 0,
    );

    //     String senderId;
    // int type;
    // String receiveId;
    // String groupId;
    // dynamic content;
    // String createTime;
    // int isRead;
    SocketUtil.webSocketInstance.add(json.encode(temple.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('老憨批'),
        centerTitle: false,
      ),
      body: Column(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(bottom: 16),
            children: <Widget>[
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: true,
              ),
              WidgetChatMessageItem(
                isOwn: true,
              ),
              WidgetChatMessageItem(
                isOwn: true,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
              WidgetChatMessageItem(
                isOwn: false,
              ),
            ],
          ).flexExtension(),
          WidgetChatInputPage(
            onSend: this.onSend,
          )
        ],
      ),
    );
  }
}
