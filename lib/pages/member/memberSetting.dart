import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/redux.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetForm.dart';

class MemberSettingPage extends StatefulWidget {
  MemberSettingPage({Key key}) : super(key: key);

  @override
  _MemberSettingPageState createState() => _MemberSettingPageState();
}

class _MemberSettingPageState extends State<MemberSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('资料修改'),
        actions: [
          FlatButton(
            onPressed: () {},
            textColor: Colors.white,
            child: Text("保存"),
          )
        ],
      ),
      body: StoreConnector<ReduxStore, EntityMemberInfo>(
        converter: (store) => store.state.memberInfo,
        builder: (_, memberInfo) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 24),
                alignment: Alignment.center,
                child: WidgetAvatarSetting(
                  url: memberInfo.avatar,
                ),
              ),
              WidgetFormInputItem()
            ],
          );
        },
      ),
    );
  }
}
