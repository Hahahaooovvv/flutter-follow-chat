import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/entity/notice/EntityNewesMessage.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/chatMessageUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
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
    ChatMessageUtil().cacheNewesMessageFromDBToReudx();

    /// TODO: 获取历史消息
    // MessageUtil().getOfflineMessage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: WidgetAppbar(title: Text("最近消息")),
      body: StoreConnector<ReduxStore, Map<dynamic, dynamic>>(
        converter: (store) => ({"messageList": store.state.newesMessageList, "briefInfo": store.state.briefMemberInfo}),
        builder: (context, _data) {
          List<EntityNewesMessage> data = _data['messageList'];
          Map<String, EnityBriefMemberInfo> briefMemberInfo = _data["briefInfo"];
          return WidgetRefresh(
            empty: data.length == 0,
            isScroll: false,
            method: () async {
              await ChatMessageUtil().cacheNewesMessageFromDBToReudx();
            },
            child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  EntityNewesMessage item = data[index];
                  EntityChatMessage element = item.message;
                  EnityBriefMemberInfo memberInfo = briefMemberInfo[element.sessionId];

                  return ListTile(
                    onTap: () {
                      ChatMessageUtil().startChat(element.sessionId);
                      // MessageUtil().startSession(context, element.sessionId, false);
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
                          DateUtil.formatDate(element.time, format: "MM-dd HH:mm"),
                          style: TextStyle(fontSize: 12.setSp(), color: Theme.of(context).textTheme.bodyText1.color.withAlpha(150)),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          [
                            element.msg,
                            "[图片消息]",
                            ["视频消息"]
                          ][element.msgType],
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.setSp()),
                          overflow: TextOverflow.ellipsis,
                        ).flexExtension(),
                        WidgetBadge(
                          noticeCount: item.unread,
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
