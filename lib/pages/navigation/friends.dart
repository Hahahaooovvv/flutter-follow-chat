import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetAppbar.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetRefresh.dart';

class FrindsPage extends StatefulWidget {
  FrindsPage({Key key}) : super(key: key);

  @override
  _FrindsPageState createState() => _FrindsPageState();
}

class _FrindsPageState extends State<FrindsPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: WidgetAppbar(
        title: Text("联系人"),
      ),
      body: StoreConnector<ReduxStore, List<EntityFriendListInfo>>(
        converter: (store) => store.state.friendList,
        builder: (context, data) {
          return WidgetRefresh(
              firstRefresh: true,
              isScroll: false,
              method: () async {
                await FriendHelper().getFriendList();
              },
              child: ListView.separated(
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
                      title: Text(item.remark ?? item.nickName ?? "", style: TextStyle(fontSize: 16.setSp())),
                      subtitle: Text(
                        "[在线] ${item.subTitle ?? ""}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.setSp()),
                      ),
                    );
                  },
                  separatorBuilder: (context, item) => Divider(),
                  itemCount: data.length));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
