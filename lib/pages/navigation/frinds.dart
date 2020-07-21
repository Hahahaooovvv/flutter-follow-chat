import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/pages/common/search.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class FrindsPage extends StatefulWidget {
  FrindsPage({Key key}) : super(key: key);

  @override
  _FrindsPageState createState() => _FrindsPageState();
}

class _FrindsPageState extends State<FrindsPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // TabController _tabController;
  @override
  void initState() {
    super.initState();
    // this._tabController = TabController(length: 3, vsync: this);
    FriendHelper().getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('联系人'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                RouterUtil.push(context, SearchPage());
              })
        ],
        // bottom: TabBar(
        //   indicatorColor: Theme.of(context).primaryColor,
        //   tabs: [Tab(text: "好友"), Tab(text: "关注"), Tab(text: "粉丝")],
        //   controller: this._tabController,
        // ),
      ),
      body: StoreConnector<ReduxStore, List<EntityFriendListInfo>>(
        converter: (store) => store.state.friendList,
        builder: (context, data) {
          return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                EntityFriendListInfo item = data[index];
                return ListTile(
                  onTap: () {
                    RouterUtil.push(context, MemnerInfoPage(memberId: item.memberId));
                  },
                  contentPadding: [8, 16].setPadding(),
                  leading: WidgetAvatar(
                    url: item.avatar,
                    size: 40.setWidth(),
                  ),
                  title: Text(item.remark ?? item.nickName),
                  subtitle: Text(
                    "Actress AspirantActress AspirantActress AspirantActress AspirantActress Aspirant",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).dividerColor.withAlpha(30)),
                );
              },
              separatorBuilder: (context, item) => Divider(),
              itemCount: data.length);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
