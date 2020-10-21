import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  double _offset;
  double _oldOffsetMax;
  bool refreshFlag = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver((this));
    this.setNameAndAvatar();
  }

  void setNameAndAvatar() async {
    await FriendHelper().cacheBriefMemberListToReduxBySessionId([this.widget.sessionId]);
    var find = ReduxUtil.store.state.briefMemberInfo[this.widget.sessionId];
    setState(() {
      this.nickName = find?.remark ?? find?.name;
      this.avatar = find?.avatar;
      this.ownAvatar = ReduxUtil.store.state.memberInfo.avatar;
      this.ownMemberId = ReduxUtil.store.state.memberInfo.memberId;
    });
  }

  jumpToEnd([bool animate = false]) {
    if (animate) {
      // 滚动到最底部
      this._scrollController.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.ease);
    } else {
      this._scrollController.jumpTo(0);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    this.jumpToEnd();
  }

  void onSend(EntityChatMessage chatMessage) async {
    chatMessage.sessionId = this.widget.sessionId;
    ChatMessageUtil().sendMessage(chatMessage);
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nickName ?? ""),
      ),
      body: StoreConnector<ReduxStore, List<EntityChatMessage>>(
        onWillChange: (_old, _new) {
          if (this.refreshFlag) {
            this.refreshFlag = false;
            return;
          }
          if (this._scrollController.offset != 0) {
            this._offset = this._scrollController.offset;
            this._oldOffsetMax = this._scrollController.position.maxScrollExtent;
          }
          CommonUtil.whenRenderEnd((duration) {
            if (_offset != null) {
              double _toOffset = (this._scrollController.position.maxScrollExtent - this._oldOffsetMax) + this._offset;
              print(_toOffset);
              this._scrollController.jumpTo(_toOffset);
              this._offset = null;
              this._oldOffsetMax = null;
            } else {
              this.jumpToEnd();
            }
          });
        },
        converter: (store) => store.state.roomMessageList ?? <EntityChatMessage>[],
        builder: (context, data) {
          return Column(
            children: <Widget>[
              EasyRefresh(
                onLoad: () async {
                  this.refreshFlag = true;
                  await Future.delayed(Duration(milliseconds: 500)).then((value) async {
                    await ChatMessageUtil().loadMoreChatingMsgs();
                  });
                  // await Future.any([ChatMessageUtil().loadMoreChatingMsgs(), Future.delayed(Duration(seconds: 2))]);
                  return;
                },
                footer: CustomFooter(
                    // enableInfiniteLoad: false,
                    extent: 40.0,
                    triggerDistance: 50.0,
                    footerBuilder: (context, loadState, pulledExtent, loadTriggerPullDistance, loadIndicatorExtent, axisDirection, float, completeDuration, enableInfiniteLoad, success, noMore) {
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ],
                      );
                    }),
                child: ListView.separated(
                  addRepaintBoundaries: false,
                  reverse: true,
                  // physics: NeverScrollableScrollPhysics(),
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
                      beforeTime: index == data.length - 1 ? null : data[index + 1].time,
                      messageEntity: item,
                      avatar: this.avatar,
                      ownAvatar: this.ownAvatar,
                    );
                  },
                  itemCount: data?.length ?? 0,
                  padding: EdgeInsets.only(bottom: 16),
                ),
              ).flexExtension(),
              WidgetChatInputPage(
                scrollToEnd: this.jumpToEnd,
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
