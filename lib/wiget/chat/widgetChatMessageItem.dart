import 'dart:async';
import 'package:flustars/flustars.dart' as Flustars;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/wiget/chat/widgetChatMessgeContent.dart';
import 'package:follow/wiget/chat/widgetMessageBubble.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetShouldReBuild.dart';

class WidgetChatMessageItem extends StatefulWidget {
  WidgetChatMessageItem({
    Key key,
    this.avatar,
    this.ownAvatar,
    this.beforeTime,
    this.onImagePress,
    this.onRePushMessage,
    @required this.messageEntity,
    this.streamController,
  }) : super(key: key);
  final EntityChatMessage messageEntity;
  final String avatar;
  final String ownAvatar;
  final DateTime beforeTime;
  final Function onImagePress;
  final Function onRePushMessage;
  final StreamController streamController;
  @override
  _WidgetChatMessageItemState createState() => _WidgetChatMessageItemState();
}

class _WidgetChatMessageItemState extends State<WidgetChatMessageItem> with AutomaticKeepAliveClientMixin {
  Timer _timer;

  Widget buildMsgContext() {
    switch (this.widget.messageEntity.msgType) {
      case 0:
        return Text(
          this.widget.messageEntity.msg ?? "",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14.setSp()),
        );
      case 1:
        return WidgetChatMessageItemLoading(
          child: WidgetShouldRebuild<WidgetChatImage>(
            child: WidgetChatImage(
              file: this.widget.messageEntity.file,
              height: this.widget.messageEntity.extend.size.height,
              msg: this.widget.messageEntity.msg,
            ),
            shouldRebuild: (oldWidget, newWidget) {
              bool _bool1 = oldWidget.msg != newWidget.msg;
              return _bool1 && (oldWidget != null && oldWidget.file?.path != newWidget.file?.path);
            },
          ),
          streamController: this.widget.messageEntity.streamController,
          width: 200,
          height: this.widget.messageEntity.extend.size.height,
        ).tapExtension(() {
          this.widget.onImagePress();
        });
      case 2:
        return WidgetChatMessageSound(sound: this.widget.messageEntity.msg);
      default:
        return Container();
    }
  }

  Widget buildStatus(BuildContext _context) {
    if (this.widget.messageEntity.status == 0) {
      // 为发送成功
      // 如果时间超过了10秒钟 则发送失败 展示错误图标
      var _timer = (DateTime.now().millisecondsSinceEpoch - this.widget.messageEntity.time.add(Duration(seconds: 10)).millisecondsSinceEpoch) / 1000;
      if (_timer > 0) {
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
                  content: Text("消息发送失败，是否重新发送"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(_context);
                          this.widget.onRePushMessage(this.widget.messageEntity);
                        },
                        child: Text("重新发送")),
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
        // 10秒中之后自动刷新状态
        this._timer = Timer(Duration(seconds: _timer.abs().ceil()), () {
          this._timer = null;
          this.setState(() {});
        });
        return CupertinoActivityIndicator();
      }
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timer != null) {
      this._timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isOwn = this.widget.messageEntity.senderId == ReduxUtil.store.state.memberInfo.memberId;
    bool showTime = true;
    if (this.widget.beforeTime != null) {
      showTime = this.widget.beforeTime.add(Duration(minutes: 4)).isBefore(this.widget.messageEntity.time);
    }
    EdgeInsets _contentPadding;
    if (this.widget.messageEntity.msgType == 2) {
      _contentPadding = EdgeInsets.symmetric(horizontal: 8.setWidth());
    } else if (this.widget.messageEntity.msgType != 0) {
      _contentPadding = EdgeInsets.zero;
    }
    return Column(
      children: [
        if (showTime) WidgetChatMessageTip(dateTime: this.widget.messageEntity.time.toString()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
          children: <Widget>[
            WidgetAvatar(url: !isOwn ? this.widget.avatar : this.widget.ownAvatar, size: 40).paddingExtension(
              EdgeInsets.only(left: 8.setWidth(), right: 8.setWidth()),
            ),
            WidgetMessageBubble(
              contentPadding: _contentPadding,
              direction: isOwn ? WidgetMessageBubbleDirectionArrowType.right : WidgetMessageBubbleDirectionArrowType.left,
              child: this.buildMsgContext(),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.setHeight()),
              width: 50,
              child: this.buildStatus(context),
            ),
          ],
        ).paddingExtension(EdgeInsets.fromLTRB(8.setWidth(), 16, 8.setWidth(), 0))
      ],
    ).paddingExtension(EdgeInsets.symmetric(vertical: 2.setHeight()));
  }

  @override
  bool get wantKeepAlive => true;
}

class WidgetChatMessageTip extends StatelessWidget {
  final String dateTime;

  const WidgetChatMessageTip({Key key, this.dateTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.setHeight()),
      child: Text(Flustars.DateUtil.formatDateStr(dateTime, format: "MM-dd HH:mm"), style: TextStyle(color: Colors.white, fontSize: 12.setSp())),
      padding: EdgeInsets.symmetric(horizontal: 8.setWidth(), vertical: 2.setHeight()),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(140),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class WidgetChatMessageItemLoading extends StatefulWidget {
  WidgetChatMessageItemLoading({
    Key key,
    @required this.child,
    @required this.width,
    @required this.height,
    @required this.streamController,
  }) : super(key: key);
  final Widget child;
  final double width;
  final double height;
  final StreamController<double> streamController;

  @override
  _WidgetChatMessageItemLoadingState createState() => _WidgetChatMessageItemLoadingState();
}

class _WidgetChatMessageItemLoadingState extends State<WidgetChatMessageItemLoading> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        this.widget.child,
        StreamBuilder<double>(
            stream: this.widget.streamController?.stream,
            builder: (context, data) {
              bool isPross = (data.data == 1 || data.data == null);
              return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: this.widget.width,
                  height: this.widget.height,
                  alignment: Alignment.center,
                  color: Colors.black.withAlpha(isPross ? 0 : 160),
                  child: isPross
                      ? Container()
                      : CircularProgressIndicator(
                          value: data.data,
                          backgroundColor: Theme.of(context).primaryColor.withAlpha(80),
                        ));
            }),
      ],
    ).containerExtension(
      width: this.widget.width,
      height: this.widget.height,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
