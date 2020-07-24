import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetRefresh.dart';

class NoticePage extends StatefulWidget {
  NoticePage({Key key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  void handleMessage(EntityNoticeTemple data, BuildContext context) {
    switch (data.type) {
      case 0:
        EntityFriendAddRec friendAddRec = EntityFriendAddRec.fromJson(data.content);
        ModalUtil().ackFriendRequestDioag(context, friendAddRec);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('系统消息'),
      ),
      body: Builder(builder: (_context) {
        return StoreConnector<ReduxStore, List<EntityNoticeTemple>>(
            converter: (store) => store.state.noticeList,
            builder: (context, data) {
              return WidgetRefresh(
                  firstRefresh: true,
                  isScroll: false,
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      EntityFriendAddRec item = EntityFriendAddRec.fromJson(data[index].content);
                      bool canHandle = !item.lunchApply && item.status == 1;
                      return ListTile(
                        onTap: canHandle ? () => this.handleMessage(data[index], _context) : null,
                        leading: Badge(
                          showBadge: item.isRead == 0,
                          child: WidgetAvatar(url: item.avatar, size: 40.setWidth()),
                        ),
                        title: Text(item.nickName + "请求添加你为好友"),
                        subtitle: Text(item.message, style: TextStyle(fontSize: 12.setSp())),
                        trailing: Text([item.lunchApply ? "等待中" : "等待验证", "已接受", "已拒绝", "已失效"][item.status - 1], style: TextStyle(fontSize: 12.setSp())),
                      );
                    },
                  ),
                  method: NoticeHelper().refreshNotice);
            });
      }),
    );
  }
}
