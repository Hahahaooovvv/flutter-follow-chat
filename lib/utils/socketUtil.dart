import 'dart:async';
import 'package:follow/config.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/chatMessageUtil.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:signalr_client/signalr_client.dart';

enum NoticeTypeEnum {
  addFriend,
}

class SocketUtil {
  static HubConnection hubConnection;

  /// 这个表示是否能重新链接
  static bool _reConnectFlag;

  /// 初始化websocket
  initSocket() async {
    hubConnection = HubConnectionBuilder()
        .withUrl('http://${Config.mainApiUrl}/chat',
            options: HttpConnectionOptions(
              accessTokenFactory: () => Future.value(ReduxUtil.store.state.memberInfo.token),
            ))
        .build();
    hubConnection.onclose(this.onClose);

    hubConnection.on("/common/message", (arguments) {
      print('socket-----------------------------');
      print(arguments);
      EntityNoticeTemple entityNoticeTemple = EntityNoticeTemple.fromJson(arguments[0]);
      CommonUtil.noticeTempleHandle(entityNoticeTemple);
    });

    hubConnection.on("/message/client/ack", (arguments) {
      print('socket-----------------------------');
      print(arguments);
      EntityChatMessage chatMessage = EntityChatMessage.fromJson(arguments[0]);
      ChatMessageUtil().ackClientMessage(chatMessage);
    });
  }

  /// 链接
  Future<void> connect([bool reConnect = false]) {
    SocketUtil._reConnectFlag = true;
    var _component = hubConnection.start();
    return _component.then((value) {
      print("socket链接上");
    }).catchError((e) {
      print("连接失败");
      if (reConnect) {
        this.reConnect();
      }
    });
  }

  // 如果未链接上 则循环链接 3秒钟一次
  Future<void> reConnect() {
    Completer<void> completer = new Completer<void>();
    Timer.periodic(Duration(seconds: 3), (_timer) {
      print("触发发重新链接");
      if (hubConnection.state == HubConnectionState.Disconnected) {
        hubConnection.start().then((value) {
          print("重新链接成功");
          // 如果链接上
          _timer.cancel();
          completer.complete();
        });
      }
    });
    return completer.future;
  }

  /// 当socket关闭时候 3秒钟一次尝试重连
  onClose(Exception error) {
    if (SocketUtil._reConnectFlag) {
      this.reConnect();
    }
  }

  /// 关闭
  void close() {
    if (hubConnection.state == HubConnectionState.Connected) {
      SocketUtil._reConnectFlag = false;
      hubConnection.stop();
    }
    // SocketUtil.webSocketInstance.close();
  }
}
