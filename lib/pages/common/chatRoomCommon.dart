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

class _ChatRoomCommonPageState extends State<ChatRoomCommonPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String nickName = "";
  String avatar = "";
  String ownAvatar = "";
  String ownMemberId = "";
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    var memberInfo = FriendHelper.getFreindInfo(this.widget.sessionId);
    this.nickName = memberInfo.nickName;
    this.avatar = memberInfo.avatar;
    this.ownAvatar = ReduxUtil.store.state.memberInfo.avatar;
    this.ownMemberId = ReduxUtil.store.state.memberInfo.memberId;
    CommonUtil.whenRenderEnd((duration) {
      // 滚动到最底部
      this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent);
    });
    WidgetsBinding.instance.addObserver((this));
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    CommonUtil.whenRenderEnd((duration) {
      // 滚动到最底部
      this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent);
    });
  }

  void onSend(String message) async {
    var _content = {"msg": message, "msgType": 0, "localMsgId": CommonUtil.randomString(), "status": 0};
    var temple = EntityNoticeTemple(
        // 消息类型 单聊
        type: 1,

        /// 发送人
        senderId: ReduxUtil.store.state.memberInfo.memberId,
        receiveId: this.widget.sessionId,
        createTime: DateTime.now().toString(),
        isRead: 1,
        content: _content);
    // 存入sqllite
    MessageUtil.handleSocketMsg(temple);
    temple.content = json.encode(_content);
    // 发送到后端
    SocketUtil.webSocketInstance.add(json.encode(temple.toJson()));
  }

  @override
  void dispose() {
    super.dispose();
    this._scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nickName ?? ""),
        centerTitle: false,
      ),
      body: StoreConnector<ReduxStore, List<MessageEntity>>(
        onDidChange: (_data) {
          this._scrollController.animateTo(this._scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.ease);
        },
        converter: (store) => store.state.messageList[this.widget.sessionId] ?? [],
        builder: (context, data) {
          List<MessageEntity> _data = data.deepCopy();
          _data.sort((a2, a1) => DateTime.parse(a2.senderTime).millisecondsSinceEpoch.compareTo(DateTime.parse(a1.senderTime).millisecondsSinceEpoch));
          return Column(
            children: <Widget>[
              ListView.separated(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                separatorBuilder: (context, index) => Container(height: 2.setHeight()),
                itemBuilder: (context, index) {
                  var item = _data[index];
                  return WidgetChatMessageItem(
                    beforeTime: index == 0 ? null : _data[index - 1].senderTime,
                    messageEntity: item,
                    avatar: this.avatar,
                    ownAvatar: this.ownAvatar,
                  );
                },
                itemCount: data?.length ?? 0,
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
