import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/reduxUtil.dart';

enum NoticeTypeEnum {
  addFriend,
}

class SocketUtil {
  static String socketUrl = "ws://localhost";
  static Stream<dynamic> mStream;
  static WebSocket webSocketInstance;

  /// 初始化websocket
  static initSocket(BuildContext context) async {
    WebSocket.connect("ws://localhost:5000?sid=${ReduxUtil.store.state.memberInfo.memberId}&platform=0").then((value) {
      webSocketInstance = value;
      mStream = webSocketInstance.asBroadcastStream();
      print("链接成功");
      mStream.listen((event) {
        // 刷新通知栏
        NoticeHelper().refreshNotice();
        EntityNoticeTemple temple = EntityNoticeTemple.fromJson(json.decode(event));
        CommonUtil.noticeTempleHandle(temple, context);
      });
    });
  }
}
