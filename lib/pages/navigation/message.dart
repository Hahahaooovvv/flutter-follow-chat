import 'package:flutter/material.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最近消息'),
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Judy West"),
                  Text(
                    "3小时前",
                    style: TextStyle(fontSize: 12.setSp(), color: Theme.of(context).textTheme.bodyText1.color.withAlpha(150)),
                  ),
                ],
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Actress AspirantActress AspirantActress AspirantActress AspirantActress Aspirant",
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
          itemCount: 10),
    );
  }
}
