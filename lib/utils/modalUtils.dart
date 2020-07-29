import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:follow/apis/friendApis.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/messageUtil.dart';
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

  static showSnackBar(Widget content, {SnackBarAction action}) {
    CommonUtil.oneContext.showSnackBar(
        builder: (_context) => SnackBar(
              margin: EdgeInsets.only(bottom: 16.setHeight() + MediaQuery.of(_context).padding.bottom, left: 16.setWidth(), right: 16.setWidth()),
              content: content,
              action: action,
              behavior: SnackBarBehavior.floating,
            ));
  }

  /// 已经推出登录弹窗
  static isSignOut() {
    CommonUtil.oneContext.showDialog(
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            content: Text("您的账号已在别处登录"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(_);
                    MemberHelper().signOut(CommonUtil.oneContext.context);
                  },
                  child: Text("确定"))
            ],
          );
        });
  }

  /// 回复添加好友请求弹窗
  ackFriendRequest(EntityNoticeTemple temple) {
    EntityFriendAddRec friendAddRec = EntityFriendAddRec.fromJson(temple.content);
    ModalUtil.showSnackBar(Text((friendAddRec.remark ?? friendAddRec.nickName) + "请求添加你为好友"),
        action: SnackBarAction(
          label: "处理",
          onPressed: () {
            ModalUtil().ackFriendRequestDioag(friendAddRec);
          },
        ));
  }

  /// 回复添加好友请求alert
  ackFriendRequestDioag(EntityFriendAddRec friendAddRec) {
    CommonUtil.oneContext.showDialog(builder: (context) {
      return AlertDialog(
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);
                await FriendApis().ack(friendAddRec.recId, null, true);
                NoticeHelper().refreshNotice();
                await FriendHelper().getFriendList();
                ModalUtil.showSnackBar(Text("你与${friendAddRec.nickName}已成为好友"),
                    action: SnackBarAction(
                        label: "聊天",
                        onPressed: () {
                          MessageUtil().startSession(CommonUtil.oneContext.context, friendAddRec.senderMemberId, false);
                        }));
              },
              child: Text("同意")),
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);
                await FriendApis().ack(friendAddRec.recId, null, false);
                NoticeHelper().refreshNotice();
                ModalUtil.showSnackBar(Text("已拒绝${friendAddRec.nickName}的好友请求"));
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
