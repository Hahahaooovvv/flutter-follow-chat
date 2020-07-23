import 'package:flutter/material.dart';
  
class MemberSettingPage extends StatefulWidget {
  MemberSettingPage({Key key}) : super(key: key);
  
  @override
  _MemberSettingPageState createState() => _MemberSettingPageState();
}
  
class _MemberSettingPageState extends State<MemberSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                // Text("输入昵称",

              ],
            ),
          )
        ],
      ),
    );
  }
}