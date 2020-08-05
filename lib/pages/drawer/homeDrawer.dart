import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/pages/notice/notice.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetImagePvreview.dart';
import 'package:follow/wiget/widgetPopSelectModal.dart';
import 'package:image_picker/image_picker.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      child: Drawer(
        child: StoreConnector<ReduxStore, Map<String, dynamic>>(
          builder: (context, data) {
            EntityMemberInfo memberInfo = data["memberInfo"];
            List<EntityNoticeTemple> notice = data["notice"];
            int noticeCount = notice.where((element) => element.isRead == 0).length;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: memberInfo.cover == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(memberInfo.cover),
                            fit: BoxFit.fitWidth,
                          ),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: EdgeInsets.fromLTRB(16.setWidth(), MediaQuery.of(context).padding.top + 32.setHeight(), 16.setWidth(), 24.setHeight()),
                  child: Row(
                    children: [
                      ClipOval(
                          child: Container(
                        width: 80.setWidth(),
                        height: 80.setWidth(),
                        child: ClipOval(child: Image.network(memberInfo.avatar)),
                        color: Colors.white,
                        padding: 2.setPaddingAll(),
                      )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(memberInfo.nickName, style: TextStyle(fontSize: 18.setSp(), color: Colors.white)),
                          Container(height: 4.setHeight()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (memberInfo.signature == null) Icon(Icons.edit, size: 16.setSp(), color: Colors.white).paddingExtension(EdgeInsets.only(right: 4.setWidth())),
                              Text(memberInfo.signature ?? "来写两句签名", style: TextStyle(fontSize: 12.setSp(), color: Colors.white), maxLines: 2).flexExtension(),
                            ],
                          )
                        ],
                      ).paddingExtension(EdgeInsets.only(left: 12.setWidth())).flexExtension(),
                    ],
                  ),
                ).tapExtension(() {
                  RouterUtil.push(context, MemnerInfoPage());
                }),
                ListTile(
                  onTap: () {
                    RouterUtil.push(context, NoticePage());
                  },
                  title: Text("系统消息"),
                  leading: Icon(Icons.notifications_none),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (noticeCount > 0) Badge(badgeContent: Text(noticeCount.toString(), style: TextStyle(color: Colors.white, fontSize: 10.setSp()))),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                // ListTile(
                //   title: Text("弗罗号"),
                //   leading: Icon(Icons.credit_card),
                //   trailing: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text(memberInfo.followId, style: TextStyle(color: Color(0XFF999999))),
                //       Icon(Icons.chevron_right),
                //     ],
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    ModalUtil.showPopSelect<String>(context, children: [
                      ...(memberInfo.cover == null ? [] : [WidgetPopSelectModalItem(childStr: "查看封面", value: "0")]),
                      WidgetPopSelectModalItem(childStr: "修改封面", value: "1"),
                    ], onSelect: (value) async {
                      print(value);
                      if (value == "1") {
                        ImageUtil().uploadImg(context, source: ImageSource.gallery, clip: true).then((value) async {
                          if (value != null) {
                            await MemberApi().settingCover(value);
                            MemberHelper().updateMemberInfo();
                          }
                        });
                      } else {
                        RouterUtil.push(
                            context,
                            WidgetImagePvreview(
                              iniIndex: 0,
                              imageList: [memberInfo.cover],
                            ));
                      }
                    });
                  },
                  title: Text("我的封面"),
                  leading: Icon(Icons.image),
                  trailing: Icon(Icons.chevron_right),
                ),
                Expanded(child: Container()),
                FlatButton(
                  onPressed: () {
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    new MemberHelper().signOut(context);
                                  },
                                  child: Text("退出")),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("不退出", style: TextStyle(color: Theme.of(context).disabledColor)))
                            ],
                            content: Text("是否退出", style: TextStyle(color: Colors.black)),
                          );
                        });
                  },
                  child: Container(
                    child: Text("退出登录"),
                    alignment: Alignment.center,
                    height: 36.setHeight() + MediaQuery.of(context).padding.bottom,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  ),
                )
              ],
            );
          },
          converter: (store) => ({"memberInfo": store.state.memberInfo, "notice": store.state.noticeList}),
        ),
      ),
      data: Theme.of(context).copyWith(
          textTheme: TextTheme(
        bodyText1: TextStyle(color: Color(0XFF333333), fontSize: 15.setSp()),
        bodyText2: TextStyle(color: Color(0XFF333333), fontSize: 15.setSp()),
      )),
    );
  }
}
