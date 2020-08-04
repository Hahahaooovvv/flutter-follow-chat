import 'package:flutter/material.dart';
import 'package:follow/apis/friendApis.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetInput.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchStr = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: Column(
        children: [
          WidgetInput(
            autofocus: true,
            onChanged: (str) {
              this.setState(() {
                searchStr = str;
              });
            },
            hintText: "请输入搜索内容",
          ).paddingExtension(16.setPaddingAll()),
          if (this.searchStr != null && this.searchStr.isNotEmpty)
            ListTile(
              title: Text("搜索用户：${this.searchStr}"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.setSp(),
                color: Theme.of(context).dividerColor.withAlpha(50),
              ),
            ).containerExtension(color: Colors.white).tapExtension(() {
              FriendApis().searchMemberInfo(searchStr).then((value) {
                if (value != null) {
                  RouterUtil.push(context, MemnerInfoPage(memberId: value.memberId));
                }
              });
            })
        ],
      ),
    );
  }
}
