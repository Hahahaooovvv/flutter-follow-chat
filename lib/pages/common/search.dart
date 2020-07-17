import 'package:flutter/material.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';

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
          TextField(
            onChanged: (str) {
              this.setState(() {
                searchStr = str;
              });
            },
            decoration: InputDecoration(
              fillColor: Color.fromRGBO(238, 238, 238, 0.8),
              filled: true,
              hintText: "请输入搜索内容",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
            ),
          ).paddingExtension(16.setPaddingAll()),
          if (this.searchStr != null && this.searchStr.isNotEmpty)
            ListTile(
              title: Text("搜索用户：${this.searchStr}"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).dividerColor.withAlpha(50),
              ),
            ).containerExtension(color: Colors.white).tapExtension(() {
              RouterUtil.push(context, MemnerInfoPage());
            })
        ],
      ),
    );
  }
}
