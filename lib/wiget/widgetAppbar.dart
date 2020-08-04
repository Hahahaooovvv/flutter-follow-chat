import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/pages/common/search.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/routerUtil.dart';

import '../redux.dart';

class WidgetAppbar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;

  WidgetAppbar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: title,
        leading: StoreConnector<ReduxStore, Map<String, dynamic>>(
            converter: (store) => ({"memberInfo": store.state.memberInfo, "notice": store.state.noticeList}),
            builder: (context, data) {
              EntityMemberInfo memberInfo = data["memberInfo"];
              List<EntityNoticeTemple> notice = data["notice"];
              int noticeCount = notice.where((element) => element.isRead == 0).length;
              return IconButton(
                  icon: Badge(
                    showBadge: noticeCount > 0,
                    child: ClipOval(child: Image.network(memberInfo.avatar)),
                  ),
                  onPressed: ModalUtil.openDrawer);
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                RouterUtil.push(context, SearchPage());
              })
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
