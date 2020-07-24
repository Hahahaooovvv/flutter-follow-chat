import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/messageUtil.dart';
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
  String nickName = "";
  String avatar = "";
  String ownAvatar = "";
  String ownMemberId = "";
  @override
  void initState() {
    super.initState();
    var memberInfo = FriendHelper.getFreindInfo(this.widget.sessionId);
    this.nickName = memberInfo.nickName;
    this.avatar = memberInfo.avatar;
    this.ownAvatar = ReduxUtil.store.state.memberInfo.avatar;
    this.ownMemberId = ReduxUtil.store.state.memberInfo.memberId;
  }

  void onSend(String message) {
    var _content = {"msg": message, "msgType": 0, "localMsgId": CommonUtil.randomString(), "status": 0};
    var temple = EntityNoticeTemple(
      // 消息类型 单聊
        type: 1,

        /// 发送人
        senderId: ReduxUtil.store.state.memberInfo.memberId,
        receiveId: this.widget.sessionId,
        createTime: DateTime.now().toIso8601String(),
        isRead: 1,
        content: _content);

    MessageUtil.handleSocketMsg(temple);
    temple.content = json.encode(_content);
    SocketUtil.webSocketInstance.add(json.encode(temple.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('老憨批'),
        centerTitle: false,
      ),
      body: StoreConnector<ReduxStore, List<MessageEntity>>(
        converter: (store) => store.state.messageList[this.widget.sessionId],
        builder: (context, data) {
          data.sort((a2, a1) => DateTime.parse(a2.senderTime).millisecondsSinceEpoch.compareTo(DateTime.parse(a1.senderTime).millisecondsSinceEpoch));
          return Column(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Container(height: 2.setHeight()),
                itemBuilder: (context, index) {
                  return WidgetChatMessageItem(
                    messageEntity: data[index],
                    avatar: this.avatar,
                    ownAvatar: this.ownAvatar,
                  );
                },
                itemCount: data.length,
                padding: EdgeInsets.only(bottom: 16),
              ).flexExtension(),
              WidgetChatInputPage(
                onSend: this.onSend,
              )
            ],
          );
        },
      ),
    );
  }
}
