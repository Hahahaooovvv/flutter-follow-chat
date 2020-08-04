import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/messageUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/wiget/widgetAppbar.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetBadge.dart';
import 'package:follow/wiget/widgetRefresh.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    MessageUtil().getOfflineMessage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: WidgetAppbar(title: Text("最近消息")),
      body: StoreConnector<ReduxStore, Map<dynamic, dynamic>>(
        converter: (store) => ({"messageList": store.state.messageList, "briefInfo": FriendHelper.getBriefMemberInfos(store.state.messageList.keys.toList())}),
        builder: (context, _data) {
          Map<String, List<MessageEntity>> data = _data['messageList'];
          Map<String, EnityBriefMemberInfo> briefMemberInfo = _data["briefInfo"];
          return WidgetRefresh(
            empty: data.length == 0,
            isScroll: false,
            method: () async {
              await MessageUtil().getOfflineMessage();
            },
            child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  List<MessageEntity> item = data[data.keys.toList()[index]];
                  List<MessageEntity> _item = item.deepCopy();
                  _item.sort((a1, a2) => DateTime.parse(a2.senderTime).millisecondsSinceEpoch.compareTo(DateTime.parse(a1.senderTime).millisecondsSinceEpoch));
                  MessageEntity element = _item[0];
                  EnityBriefMemberInfo memberInfo = briefMemberInfo[element.sessionId];
                  return ListTile(
                    onTap: () {
                      MessageUtil().startSession(context, element.sessionId, false);
                    },
                    contentPadding: [8, 16].setPadding(),
                    leading: WidgetAvatar(
                      url: memberInfo?.avatar ?? null,
                      size: 40.setWidth(),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(memberInfo?.remark ?? memberInfo?.nameOrRemark ?? "", style: TextStyle(fontSize: 16.setSp())),
                        Text(
                          DateUtil.formatDateStr(element.senderTime, format: "MM-dd HH:mm"),
                          style: TextStyle(fontSize: 12.setSp(), color: Theme.of(context).textTheme.bodyText1.color.withAlpha(150)),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          element.msg,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.setSp()),
                          overflow: TextOverflow.ellipsis,
                        ).flexExtension(),
                        WidgetBadge(
                          noticeCount: _item.where((element) => element.isRead == 0 && element.senderId != ReduxUtil.store.state.memberInfo.memberId).length,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, element) => Divider(),
                itemCount: data.length),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
