import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:follow/apis/msgApis.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/entity/notice/EntityNewesMessage.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/pages/common/chatRoomCommon.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/filesUtil.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

class ChatMessageUtil {
  /// 开始聊天
  void startChat(String sessionId) async {
    /// 首先读取db的数据 读取线上数据=>
    List<EntityChatMessage> _list = [];
    var select = await SqlLiteUtil.dbInstance.rawQuery("select * from chat_msg where sessionId=? order by time", [sessionId]).toListMap();
    select.forEach((element) {
      var _obj = EntityChatMessage.fromJson(element);
      _list.add(_obj);
    });
    ReduxUtil.dispatch(ReduxActions.CHAT_SESSION_ID, sessionId);
    await this.cacheToChatingRedux(_list);
    FriendHelper().cacheBriefMemberListToReduxBySessionId([sessionId]);
    RouterUtil.push(CommonUtil.oneContext.context, ChatRoomCommonPage(sessionId: sessionId, isGroup: 0));
  }

  void endChat() {
    ReduxUtil.dispatch(ReduxActions.ROOM_MESSAGE, <EntityChatMessage>[]);
    ReduxUtil.dispatch(ReduxActions.CHAT_SESSION_ID, null);
    this.cacheNewesMessageFromDBToReudx();
  }

  Future<List<EntityNewesMessage>> cacheNewesMessageFromDBToReudx() async {
    List<EntityNewesMessage> _list = [];
    var select = await SqlLiteUtil.dbInstance.rawQuery('''
     SELECT
      stu.* ,ifnull(c1.onread,0) unread
    FROM
      ( SELECT * FROM chat_msg ORDER BY time DESC ) stu
    LEFT JOIN 
      (SELECT sessionId,COUNT(id) onread FROM chat_msg WHERE isRead=0 AND senderId!=? GROUP BY sessionId) c1 on c1.sessionId = stu.sessionId
    GROUP BY
      stu.sessionId 
    ORDER BY
      time DESC;
    ''', [ReduxUtil.store.state.memberInfo.memberId]).toListMap();
    select.forEach((element) {
      _list.add(EntityNewesMessage()
        ..message = EntityChatMessage.fromJson(element)
        ..unread = element["unread"]);
    });
    FriendHelper().cacheBriefMemberListToReduxBySessionId(_list.map((e) => e.message.sessionId).toList());
    ReduxUtil.dispatch(ReduxActions.NEWES_MESSAGE, _list);
    return _list;
  }

  /// 获取线上的数据
  Future<void> getNewesMsgFromServer() async {
    await MsgApis().getNewesMsgList().then((value) async {
      await SqlLiteUtil().setSystemConfig(SqlUtilConfigKey.NEWES_LIST, value: DateTime.fromMillisecondsSinceEpoch(value.time).toString());
      await this.cacheMessageToDB(value.list);
      await this.cacheNewesMessageFromDBToReudx();
    });
  }

  /// 发送聊天消息
  void sendMessage(EntityChatMessage chatMessage) async {
    if (chatMessage.msgType != 0) {
      // 需要上传文件
      chatMessage.localStatus = 1;
      FileUtil().fileUpload(chatMessage.localId, filePath: chatMessage.msg, fileType: chatMessage.msgType).then((value) {
        this.cacheToChatingRedux([chatMessage]);
        // 上传完毕后删除
        value.response.then((_value) {
          value.streamController?.close();
          // 文件上传完成之后
          chatMessage.localStatus = 2;
          chatMessage.msg = _value.data.data;
          SocketUtil.hubConnection.invoke("SendChatMessage", args: [json.encode(chatMessage.toJson())]);
        });
      });
    } else {
      chatMessage.localStatus = 2;
      SocketUtil.hubConnection.invoke("SendChatMessage", args: [json.encode(chatMessage.toJson())]);
    }
    // 存到数据库
    this.cacheMessageToDB([chatMessage]);
    // 存到redux
    this.cacheToChatingRedux([chatMessage]);
    // 发送给服务端
  }

  /// 接收消息
  void receiveMessage(EntityChatMessage chatMessage) async {
    // 存入数据库
    await this.cacheMessageToDB([chatMessage]);
    if (ReduxUtil.store.state.chatingSessionId != null) {
      this.cacheNewesMessageFromDBToReudx();
    }
  }

  Future<void> cacheToChatingRedux(List<EntityChatMessage> chatMessages) async {
    // 如果ID是一样的 就存入redux
    List<EntityChatMessage> data = ReduxUtil.store.state.roomMessageList.deepCopy();
    await Future.forEach<EntityChatMessage>(chatMessages, (element) async {
      if (element.sessionId == ReduxUtil.store.state.chatingSessionId) {
        int _index = ReduxUtil.store.state.roomMessageList.indexWhere((p) => (p.msgId == element.msgId && p.msgId != null) || p.localId == element.localId && p.localId != null);
        if (element.msgType != 0) {
          if (_index > -1 && data[_index].file != null) {
            element.file = data[_index].file;
          } else if (!element.msg.startsWith("http")) {
            element.file = File(element.msg);
          }
          element.streamController = FileUtil.messageStreamControllers.firstWhere((_element) => _element.id == element.localId, orElse: () => null)?.streamController;
          if (element.msgType == 1) {
            // 如果是图片
            if (element.msg.startsWith("http")) {
              List<double> widthList = RegExp(r"\d*x\d*").stringMatch(element.msg).split("x").map((e) => double.parse(e)).toList();
              element.extend = EntityChatMessageExtend()..size = Size(200, widthList[1] / (widthList[0] / 200));
            } else {
              var _size = await ImageUtil().getImageSize(File(element.msg));
              element.extend = EntityChatMessageExtend()..size = Size(200, _size.height / (_size.width / 200));
            }
          }
        }
        if (_index > -1) {
          // 如果是线上回执过来的消息 就不改变原msg到redux 防止重绘
          // if (element.status == 1 && element.status != data[_index].status) {
          //   element.msg = data[_index].msg;
          // }
          data[_index] = element;
        } else {
          data.add(element);
        }
      }
      // 排序
      data.sort((b1, a1) => b1.time.millisecondsSinceEpoch.compareTo(a1.time.millisecondsSinceEpoch));
    });
    // chatMessages.forEach();
    ReduxUtil.dispatch(ReduxActions.ROOM_MESSAGE, data);
  }

  /// 服务端告知前端消息已经发送成功 需更改一些数据
  Future<void> ackClientMessage(EntityChatMessage chatMessage) async {
    await this.deleteMessageFromDBByLocalId([chatMessage.localId]);
    this.cacheMessageToDB([chatMessage]);
    this.cacheToChatingRedux([chatMessage]);
  }

  /// 缓存数据到数据库
  Future<void> cacheMessageToDB(List<EntityChatMessage> chatMessage) async {
    if (chatMessage.length == 0) {
      return;
    }
    var ids = chatMessage.map((e) => e.msgId).toList();
    bool localMessage = (chatMessage.length == 1 && chatMessage[0].msgId == null);
    var dbMessageList = localMessage ? [] : await this.getMessageFromDB(ids);
    List<int>.generate(chatMessage.length, (index) => index).forEach((p) {
      var item = chatMessage[p];
      var find = dbMessageList.firstWhere((element) => element.msgId == item.msgId, orElse: () => null);
      if (find != null) {
        chatMessage[p] = chatMessage[p].merge(find);
      }
    });
    SqlUtilTemple sqlInfo = chatMessage.toList().getInsertDbTStr();
    if (!localMessage) await this.deleteMessageFromDB(ids);
    await SqlLiteUtil.execute(sqlInfo.sqlStr, sqlInfo.dataList);
  }

  /// 删除一些数据
  Future<void> deleteMessageFromDB(List<String> msgIds) async {
    var keys = List<String>.generate(msgIds.length, (index) => "?").join(",");
    await SqlLiteUtil.execute("delete from chat_msg where msgId in($keys)", msgIds);
  }

  /// 删除一些数据
  Future<void> deleteMessageFromDBByLocalId(List<String> msgIds) async {
    var keys = List<String>.generate(msgIds.length, (index) => "?").join(",");
    await SqlLiteUtil.execute("delete from chat_msg where localId in($keys)", msgIds);
  }

  /// 从数据库里面获取一些东西
  Future<List<EntityChatMessage>> getMessageFromDB(List<String> msgIds) async {
    List<EntityChatMessage> _list = [];
    var keys = List<String>.generate(msgIds.length, (index) => "?").join(",");
    var select = await SqlLiteUtil.dbInstance.rawQuery("select * from chat_msg where msgId in($keys)", msgIds).toListMap();
    select.forEach((element) {
      _list.add(EntityChatMessage.fromJson(element));
    });
    return _list;
  }

  /// TODO: 需要优化socket的地方
  /// 回复的好友添加消息
  handleFriendRequestAck(EntityNoticeTemple temple) {
    NoticeHelper().refreshNotice();
    EntityFriendAddRec friendAddRec = EntityFriendAddRec.fromJson(temple.content);
    String _status = "";
    if (friendAddRec.status == 2) {
      _status = "通过";
      FriendHelper().getFriendList();
    } else {
      _status = "拒绝";
    }
    // ignore: unnecessary_brace_in_string_interps
    String msg = "${friendAddRec.remark ?? friendAddRec.nickName}${_status}了你的好友请求";
    CommonUtil.oneContext.showSnackBar(builder: (_context) {
      return SnackBar(
          content: Text(msg),
          action: friendAddRec.status == 2
              ? SnackBarAction(
                  label: "发起聊天",
                  onPressed: () {
                    return ChatMessageUtil().startChat(temple.senderId);
                  })
              : null);
    });
  }
}
