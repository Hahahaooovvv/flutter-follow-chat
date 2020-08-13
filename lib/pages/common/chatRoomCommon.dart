import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/chatMessageUtil.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/chat/widgetChatInput.dart';
import 'package:follow/wiget/chat/widgetChatMessageItem.dart';
import 'package:follow/wiget/widgetImagePvreview.dart';

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

class _ChatRoomCommonPageState extends State<ChatRoomCommonPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  String nickName = "";
  String avatar = "";
  String ownAvatar = "";
  String ownMemberId = "";
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    CommonUtil.whenRenderEnd((duration) {
      // 滚动到最底部
      this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent);
    });
    WidgetsBinding.instance.addObserver((this));
    this.setNameAndAvatar();
  }

  void setNameAndAvatar() {
    var memberInfo = FriendHelper.getBriefMemberInfos([this.widget.sessionId]);
    var find = memberInfo[this.widget.sessionId];
    this.nickName = find?.remark ?? find?.name;
    this.avatar = find?.avatar;
    this.ownAvatar = ReduxUtil.store.state.memberInfo.avatar;
    this.ownMemberId = ReduxUtil.store.state.memberInfo.memberId;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    CommonUtil.whenRenderEnd((duration) {
      // 滚动到最底部
      this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent);
    });
  }

  void onSend(int msgType, String message) async {
    ChatMessageUtil().sendMessage(EntityChatMessage.formFastSend(
      setMsg: message,
      setSessionId: this.widget.sessionId,
      setMsgType: msgType,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    this._scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    ChatMessageUtil().endChat();
  }

  /// 点击图片
  void _onImagePress(int _index, List<String> _imgList) {
    RouterUtil.push(context, WidgetImagePvreview(iniIndex: _index, imageList: _imgList), RouterAnimationType.fade);
  }

  /// 从新发送消息
  void _onRePushMessage(EntityChatMessage messageEntity) async {
    ChatMessageUtil().sendMessage(messageEntity
      ..id = null
      ..time = DateTime.now());
    // await MessageUtil().deleteMessage(messageEntity.sessionId, localMsgIds: [messageEntity.localMsgId]);
    // this.onSend(messageEntity.msgType, messageEntity.msg);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nickName ?? ""),
        centerTitle: false,
      ),
      body: StoreConnector<ReduxStore, Map<String, dynamic>>(
        onDidChange: (_data) {
          Map<String, EnityBriefMemberInfo> brief = _data['briefInfo'];
          if (brief[this.widget.sessionId]?.nameOrRemark != this.nickName) {
            this.setState(() {
              this.nickName = brief[this.widget.sessionId]?.nameOrRemark;
            });
          }
          this._scrollController.animateTo(this._scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.ease);
        },
        converter: (store) => {
          "messageEntity": store.state.roomMessageList ?? <EntityChatMessage>[],
          "briefInfo": FriendHelper.getBriefMemberInfos([this.widget.sessionId])
        },
        builder: (context, storeData) {
          List<EntityChatMessage> data = storeData['messageEntity'];
          Map<String, EnityBriefMemberInfo> brief = storeData['briefInfo'];
          return Column(
            children: <Widget>[
              ListView.separated(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                separatorBuilder: (context, index) => Container(height: 2.setHeight()),
                itemBuilder: (context, index) {
                  var item = data[index];
                  return WidgetChatMessageItem(
                    onRePushMessage: this._onRePushMessage,
                    onImagePress: () {
                      List<EntityChatMessage> _wherelist = data.where((element) => element.msgType == 1).toList();
                      int _findIndex = _wherelist.indexWhere((element) => (element.msgId != null && element.msgId == item.msgId) || (element.localId != null && element.localId == item.localId));
                      this._onImagePress(_findIndex, _wherelist.map((e) => e.msg).toList());
                    },
                    beforeTime: index == 0 ? null : data[index - 1].time,
                    messageEntity: item,
                    avatar: brief[this.widget.sessionId]?.avatar,
                    ownAvatar: this.ownAvatar,
                  );
                },
                itemCount: data?.length ?? 0,
                padding: EdgeInsets.only(bottom: 16),
              ).flexExtension(),
              WidgetChatInputPage(
                scrollToEnd: () {
                  this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent);
                },
                onSend: this.onSend,
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
