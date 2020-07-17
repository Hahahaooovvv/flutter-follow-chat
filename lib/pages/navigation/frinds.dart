import 'package:flutter/material.dart';
import 'package:follow/pages/common/search.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class FrindsPage extends StatefulWidget {
  FrindsPage({Key key}) : super(key: key);

  @override
  _FrindsPageState createState() => _FrindsPageState();
}

class _FrindsPageState extends State<FrindsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系人'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {
          RouterUtil.push(context, SearchPage());
        })],
        bottom: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [Tab(text: "好友"), Tab(text: "关注"), Tab(text: "粉丝")],
          controller: this._tabController,
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, item) {
            return ListTile(
              onTap: () {
                RouterUtil.push(context, MemnerInfoPage());
              },
              contentPadding: [8, 16].setPadding(),
              leading: WidgetAvatar(
                url: null,
                size: 40.setWidth(),
              ),
              title: Text("Judy West"),
              subtitle: Text(
                "Actress AspirantActress AspirantActress AspirantActress AspirantActress Aspirant",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).dividerColor.withAlpha(30)),
            );
          },
          separatorBuilder: (context, item) => Divider(),
          itemCount: 10),
    );
  }
}
