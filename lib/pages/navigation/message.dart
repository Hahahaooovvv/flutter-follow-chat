import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/wiget/widgetAppbar.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(title: Text("最近消息")),
      body: StoreConnector<ReduxStore, Map<String, List<MessageEntity>>>(
        converter: (store) => store.state.messageList,
        builder: (context, data) {
          return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var item = data[data.keys.toList()[index]];
                var memberInfo = FriendHelper.getFreindInfo(item[0].sessionId);
                item.sort((a1, a2) => DateTime.parse(a2.senderTime).millisecondsSinceEpoch.compareTo(DateTime.parse(a1.senderTime).millisecondsSinceEpoch));
                return ListTile(
                  onTap: () {
                    // RouterUtil.push(context, ChatRoomCommonPage());
                  },
                  contentPadding: [8, 16].setPadding(),
                  leading: WidgetAvatar(
                    url: memberInfo?.avatar ?? null,
                    size: 40.setWidth(),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(memberInfo?.remark ?? memberInfo?.nickName ?? ""),
                      Text(
                        item[0].senderTime,
                        style: TextStyle(fontSize: 12.setSp(), color: Theme.of(context).textTheme.bodyText1.color.withAlpha(150)),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item[0].msg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).flexExtension(),
                      ClipOval(
                        child: Container(
                          width: 5,
                          height: 5,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, item) => Divider(),
              itemCount: data.length);
        },
      ),
    );
  }
}
