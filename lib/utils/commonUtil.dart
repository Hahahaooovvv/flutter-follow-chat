import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow/bottomNavigationBar.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/utils/messageUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtil {
  /// 初始化数据
  /// 每次进APP的时候在入口处调用
  initSystem(BuildContext context) {
    MemberHelper memberHelper = new MemberHelper();
    memberHelper.getMemberInfoFromLocal().then((value) {
      if (value != null) {
        memberHelper.cacheMemberInfoToRedux(value);
        // 初始化通知
        NoticeHelper().refreshNotice();
        // 初始化好友通知
        FriendHelper().getFriendList();
        MessageUtil.cacheToRedux();

        RouterUtil.replace(context, BottomNavigationBarPage());
      }
    });
  }

  /// 等待组件渲染完成回调
  static whenRenderEnd(Function(Duration duration) func) {
    WidgetsBinding.instance.addPostFrameCallback(func);
  }

  static closeKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 获取持久化储存对象
  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  /// 处理消息
  static noticeTempleHandle(EntityNoticeTemple temple, BuildContext context) {
    switch (temple.type) {
      case 0:
        ModalUtil().ackFriendRequest(context, temple);
        break;
      case 1:
        MessageUtil.handleSocketMsg(temple);
        break;
      case 2:
        MessageUtil.handleSocketMsgAck(temple);
        break;
      default:
        break;
    }
  }

  static String randomString([length = 32]) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = length;

    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }
}
