import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:follow/apis/friendApis.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/pages/member/memberInfo.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetPopSelectModal.dart';

class ModalUtil {
  /// 底部弹出选择栏
  static showPopSelect<T>(
    BuildContext context, {
    @required List<WidgetPopSelectModalItem> children,
    @required void Function(T value) onSelect,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WidgetPopSelectModal<T>(
            onSelect: onSelect,
            children: children,
          );
        });
  }

  static GlobalKey<ScaffoldState> scaffoldkey;

  static openDrawer() {
    ModalUtil.scaffoldkey.currentState.openDrawer();
  }

  static closeDrawer() {
    ModalUtil.scaffoldkey.currentState.openEndDrawer();
  }

  static showRule(
    BuildContext context, {
    Function() onpressed,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onpressed();
                  },
                  child: Text("我同意"))
            ],
            content: Text("-本Demo软件仅作为学习使用，无任何商业用途。\r\n-请勿用作其他使用，本demo代码已开源，请保护自己的个人信息。\r\n-如有使用代码需求请联系作者（登录后会有作者好友）"),
          );
        });
  }

  static showLoading() {
    EasyLoading.show();
  }

  static dismissLoading() {
    EasyLoading.dismiss();
  }

  /// 吐司
  static toastMessage(String message, {Duration duration}) {
    duration = Duration(milliseconds: 1500);
    EasyLoading.showToast(message, duration: duration);
  }

  static showSnackBar(Widget content, {SnackBarAction action, BuildContext context}) {
    if (context != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: content,
        action: action,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ModalUtil.scaffoldkey.currentState..hideCurrentSnackBar();
      ModalUtil.scaffoldkey.currentState.showSnackBar(SnackBar(
        content: content,
        action: action,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  /// 回复添加好友请求弹窗
  ackFriendRequest(BuildContext context, EntityNoticeTemple temple) {
    EntityFriendAddRec friendAddRec = EntityFriendAddRec.fromJson(temple.content);
    ModalUtil.showSnackBar(Text((friendAddRec.remark ?? friendAddRec.nickName) + "请求添加你为好友"),
        action: SnackBarAction(
          label: "处理",
          onPressed: () => ModalUtil().ackFriendRequestDioag,
        ));
    ;
  }

  ackFriendRequestDioag(BuildContext _context, EntityFriendAddRec friendAddRec) {
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await FriendApis().ack(friendAddRec.recId, null, true);
                    NoticeHelper().refreshNotice();
                    await FriendHelper().getFriendList();
                    ModalUtil.showSnackBar(Text("你与${friendAddRec.nickName}已成为好友"), action: SnackBarAction(label: "聊天", onPressed: () {}), context: _context);
                  },
                  child: Text("同意")),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await FriendApis().ack(friendAddRec.recId, null, false);
                    NoticeHelper().refreshNotice();
                    ModalUtil.showSnackBar(Text("已拒绝${friendAddRec.nickName}的好友请求"), context: _context);
                  },
                  child: Text(
                    "不同意",
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  )),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "忽略",
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ))
            ],
            title: Text("交友请求"),
            content: Container(
              child: Text(friendAddRec.message),
            ),
          );
        });
  }
}
