import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:follow/config.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

enum NoticeTypeEnum {
  addFriend,
}

class SocketUtil {
  static Stream<dynamic> mStream;
  static WebSocket webSocketInstance;

  /// 初始化websocket
  static initSocket(BuildContext context) async {
    WebSocket.connect("${Config.instance.apiUrlsConfig.ws}?sid=${ReduxUtil.store.state.memberInfo.memberId}&platform=${Platform.isAndroid ? 0 : 1}").then((value) {
      webSocketInstance = value;
      mStream = webSocketInstance.asBroadcastStream();
      mStream.listen((event) {
        // 刷新通知栏
        NoticeHelper().refreshNotice();
        EntityNoticeTemple temple = EntityNoticeTemple.fromJson(json.decode(event));
        print(event);
        CommonUtil.noticeTempleHandle(temple);
      });
    });
  }

  /// 关闭
  void close() {
    SocketUtil.webSocketInstance.close();
  }
}
