import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

class AddFriendsPage extends StatefulWidget {
  AddFriendsPage({Key key}) : super(key: key);

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
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
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "你好，我是XXX",
                fillColor: Colors.white,
                border: InputBorder.none,
                filled: true,
              ),
            ).paddingExtension(EdgeInsets.only(top: 8.setHeight(), bottom: 16.setHeight())),
            Text("好友备注", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))),
            TextField(
              decoration: InputDecoration(hintText: "张登豪", fillColor: Colors.white, border: InputBorder.none, filled: true),
            ).paddingExtension(EdgeInsets.only(top: 8.setHeight())),
          ],
        ),
        padding: 16.setPaddingAll(),
      ),
    );
  }
}
