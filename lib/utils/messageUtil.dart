import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/helper/friendHelper.dart';
import 'package:follow/helper/noticeHelper.dart';
import 'package:follow/pages/common/chatRoomCommon.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

class MessageUtil {
  /// 开始聊天
  startSession(BuildContext context, String sessionId, bool isGroup) async {
    // 未读便已读
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    await sqlLiteHelper.openDataBase();
    String strSql = "update chat_message set is_read=1 where session_id=?;";
    await sqlLiteHelper.database.rawUpdate(strSql, [sessionId]);
    sqlLiteHelper.closeDataBase();
    if (data[sessionId] != null) {
      data[sessionId] = data[sessionId].map((e) {
        e.isRead = 1;
        return e;
      }).toList();
    }
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
    MemberApi().isRead(sessionId);
    this.getOfflineMessage(sessionId);
    // 前往
    RouterUtil.push(
        context,
        ChatRoomCommonPage(
          sessionId: sessionId,
          isGroup: isGroup ? 1 : 0,
        ));
  }

  /// 获取历史未读消息
  getOfflineMessage([String sessionId]) {
    MemberApi().getOfflineChatMessage(sessionId).then((value) {
      if (value == null || value.length == 0) {
        return;
      }
      this.handleSocketMsgList(value);
    });
  }

  static SqlTemple getSocketMsgSqlStr(EntityNoticeTemple temple) {
    String str = "insert into chat_message(sender_id,session_id,chat_type,is_read,sender_time,msg_type,msg,at_members,status,msgId,local_msg_id) values(?,?,?,?,?,?,?,?,?,?,?);";
    if (temple.content is String) {
      temple.content = json.decode(temple.content);
    }
    Map<dynamic, dynamic> _map = temple.content;
    return SqlTemple()
      ..sqlStr = str
      ..dataList = [
        temple.senderId,
        getSessionId(temple.senderId, temple.receiveId),
        temple.type,
        _map['isRead'] ?? 0,
        temple.createTime,
        _map['msgType'],
        _map['msg'],
        null,
        _map['status'],
        _map['msgId'] ?? _map["recId"],
        _map['localMsgId']
      ];
  }

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
                    return MessageUtil().startSession(CommonUtil.oneContext.context, temple.senderId, false);
                  })
              : null);
    });
  }

  static getSessionId(String senderId, String receiveId) {
    if (senderId == ReduxUtil.store.state.memberInfo.memberId) {
      return receiveId;
    } else {
      return senderId;
    }
  }

  // 发送了消息 设置status
  static void handleSocketMsgAck(EntityNoticeTemple temple) async {
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    await sqlLiteHelper.openDataBase();
    String strSql = "update chat_message set status=?,msgId=? where local_msg_id=?;";
    await sqlLiteHelper.database.rawUpdate(strSql, [temple.content['status'], temple.content['msgId'], temple.content["localMsgId"]]);
    sqlLiteHelper.closeDataBase();
    var list = data[temple.senderId];
    var find = list.firstWhere((element) => element.localMsgId == temple.content['localMsgId'], orElse: () => null);
    if (find != null) {
      find.status = temple.content['status'];
      find.msgId = temple.content['msgId'];
      ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
    }
  }

  /// 处理多条消息
  Future<void> handleSocketMsgList(List<EntityNoticeTemple> temples) async {
    // Map<dynamic, dynamic> _map = temple.content;
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    await sqlLiteHelper.openDataBase();
    String strSql = "";
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    List<String> recIds = [];
    List<dynamic> strDataList = [];
    temples.forEach((e) {
      var item = MessageUtil.getSocketMsgSqlStr(e);
      strSql += item.sqlStr;
      strDataList.addAll(item.dataList);
      Map<dynamic, dynamic> _map = e.content;
      recIds.add("'${_map['recId']}'");
      bool isSender = e.senderId == ReduxUtil.store.state.memberInfo.memberId;
      MessageEntity entity = MessageEntity()
        ..senderId = e.senderId
        ..sessionId = getSessionId(e.senderId, e.receiveId)
        ..chatType = e.type
        ..isRead = _map['isRead'] ?? 0
        ..senderTime = e.createTime
        ..msgType = _map['msgType']
        ..msg = _map['msg']
        ..atMembers = _map['atMembers']
        ..status = isSender ? 0 : 1
        ..localMsgId = _map['localMsgId']
        ..msgId = _map['msgId'] ?? _map["recId"];
      if (data[getSessionId(e.senderId, e.receiveId)] != null) {
        if (!data[getSessionId(e.senderId, e.receiveId)].any((element) => element.msgId == (_map['msgId'] ?? _map["recId"]))) {
          data[getSessionId(e.senderId, e.receiveId)].add(entity);
        }
      } else {
        data[getSessionId(e.senderId, e.receiveId)] = <MessageEntity>[entity];
      }
    });
    await sqlLiteHelper.database.rawDelete("delete from chat_message where msgId in(${recIds.join(',')})");
    await sqlLiteHelper.database.rawInsert(strSql, strDataList);
    sqlLiteHelper.closeDataBase();
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
    // bool isSender = temple.senderId == ReduxUtil.store.state.memberInfo.memberId;
    // // 开始回执已收到  如果不是自己发送的
    // if (!isSender) {
    //   SocketUtil.webSocketInstance.add(EntityNoticeTemple(content: _map['offlineId'], type: 2, isRead: 0, createTime: DateTime.now().toIso8601String()).toJson().jsonEncode());
    // }
  }

  /// 删除消息 传那个根据那个删除
  Future<void> deleteMessage(
    String sessionId, {
    List<String> msgIds,
    List<String> localMsgIds,
  }) async {
    List _msgIds = msgIds ?? localMsgIds ?? [];
    if (_msgIds.length == 0) {
      return;
    }
    String _msgKey = msgIds != null ? "msgId" : "local_msg_id";

    String _idsStr = _msgIds.map((e) => "?").join(",");

    // 逻辑是修改当前消息的时间 然后从新发送
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    await sqlLiteHelper.openDataBase();
    String strSql = "delete from chat_message where $_msgKey in($_idsStr)";
    await sqlLiteHelper.database.rawDelete(strSql, _msgIds);
    var list = data[sessionId];
    list.removeWhere((element) => _msgIds.contains(msgIds != null ? element.msgId : element.localMsgId));
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
    sqlLiteHelper.closeDataBase();
  }

  /// 处理单条消息
  static Future<void> handleSocketMsg(EntityNoticeTemple temple) async {
    Map<dynamic, dynamic> _map = temple.content;
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    await sqlLiteHelper.openDataBase();
    SqlTemple sqlTemple = MessageUtil.getSocketMsgSqlStr(temple);
    await sqlLiteHelper.database.rawInsert(sqlTemple.sqlStr, sqlTemple.dataList);
    sqlLiteHelper.closeDataBase();
    bool isSender = temple.senderId == ReduxUtil.store.state.memberInfo.memberId;
    // 开始回执已收到  如果不是自己发送的
    if (!isSender) {
      SocketUtil.webSocketInstance.add(EntityNoticeTemple(content: _map['offlineId'], type: 2, isRead: 0, createTime: DateTime.now().toIso8601String()).toJson().jsonEncode());
    }
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    MessageEntity entity = MessageEntity()
      ..senderId = temple.senderId
      ..sessionId = getSessionId(temple.senderId, temple.receiveId)
      ..chatType = temple.type
      ..isRead = _map["isRead"] ?? 0
      ..senderTime = temple.createTime
      ..msgType = _map['msgType']
      ..msg = _map['msg']
      ..atMembers = _map['atMembers']
      ..status = isSender ? 0 : 1
      ..localMsgId = _map['localMsgId']
      ..msgId = _map['msgId'] ?? _map["recId"];
    if (data[getSessionId(temple.senderId, temple.receiveId)] != null) {
      data[getSessionId(temple.senderId, temple.receiveId)].add(entity);
    } else {
      data[getSessionId(temple.senderId, temple.receiveId)] = <MessageEntity>[entity];
    }
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
  }

  static Future<Map<String, List<MessageEntity>>> cacheToRedux() async {
    String strSql = "select * from chat_message";
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    await sqlLiteHelper.openDataBase();
    List<Map<String, dynamic>> dbData = sqlLiteHelper.getMapFromQueryData(await sqlLiteHelper.database.rawQuery(strSql));
    sqlLiteHelper.closeDataBase();
    Map<String, List<MessageEntity>> _map = {};

    dbData.forEach((element) {
      MessageEntity entity = MessageEntity()
        ..senderId = element["sender_id"]
        ..sessionId = element['session_id']
        ..chatType = element['chat_type']
        ..isRead = element['is_read']
        ..senderTime = element['sender_time']
        ..msgType = element['msg_type']
        ..msg = element['msg']
        ..atMembers = element['at_members']
        ..status = element['status']
        ..localMsgId = element["local_msg_id"]
        ..msgId = element['msgId'];
      if (_map[element['session_id']] != null) {
        _map[element['session_id']].add(entity);
      } else {
        _map[element['session_id']] = [entity];
      }
    });
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, _map);
    return _map;
  }
}
