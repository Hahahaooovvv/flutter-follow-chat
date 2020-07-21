import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow/apis/friendApis.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

class AddFriendsPage extends StatefulWidget {
  AddFriendsPage({Key key, @required this.memberId, @required this.name}) : super(key: key);
  final String memberId;
  final String name;
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  String message;
  String remark;

  /// 添加好友通知
  addFreindNotice() {
    FriendApis().apply(this.widget.memberId, message ?? "你好，我是" + ReduxUtil.store.state.memberInfo.nickName, remark, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('申请添加好友'),
        actions: [
          FlatButton(onPressed: () {}, child: Text("发送请求"), textColor: Colors.white),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("发送添加朋友的申请", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))),
            TextField(
              onChanged: (text) {
                this.message = text;
              },
              maxLength: 50,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "你好，我是" + ReduxUtil.store.state.memberInfo.nickName,
                fillColor: Colors.white,
                border: InputBorder.none,
                filled: true,
              ),
            ).paddingExtension(EdgeInsets.only(top: 8.setHeight(), bottom: 16.setHeight())),
            Text("好友备注", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))),
            TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              onChanged: (text) {
                this.remark = text;
              },
              decoration: InputDecoration(hintText: this.widget.name, fillColor: Colors.white, border: InputBorder.none, filled: true),
            ).paddingExtension(EdgeInsets.only(top: 8.setHeight())),
          ],
        ),
        padding: 16.setPaddingAll(),
      ),
    );
  }
}
