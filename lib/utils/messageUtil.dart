import 'dart:convert';

import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

class MessageUtil {
  static SqlTemple getSocketMsgSqlStr(EntityNoticeTemple temple) {
    String str = "insert into chat_message(sender_id,session_id,chat_type,is_read,sender_time,msg_type,msg,at_members,status,msgId,local_msg_id) values(?,?,?,?,?,?,?,?,?,?,?)";
    if (temple.content is String) {
      temple.content = json.decode(temple.content);
    }
    Map<dynamic, dynamic> _map = temple.content;
    return SqlTemple()
      ..sqlStr = str
      ..dataList = [temple.senderId, getSessionId(temple.senderId, temple.receiveId), temple.type, 0, temple.createTime, _map['msgType'], _map['msg'], null, 1, _map["msgId"], _map['localMsgId']];
  }

  static getSessionId(String senderId, String receiveId) {
    if (senderId == ReduxUtil.store.state.memberInfo.memberId) {
      return receiveId;
    } else {
      return senderId;
    }
  }

  static void handleSocketMsgAck(EntityNoticeTemple temple) async {
    SqlLiteHelper sqlLiteHelper = new SqlLiteHelper();
    await sqlLiteHelper.openDataBase();
    String strSql = "update chat_message set status=? where local_msg_id=?";
    await sqlLiteHelper.database.rawUpdate(strSql, [temple.content['status'], temple.content["localMsgId"]]);
    sqlLiteHelper.closeDataBase();
    Map<String, List<MessageEntity>> data = ReduxUtil.store.state.messageList;
    var list = data[temple.senderId];
    var find = list.firstWhere((element) => element.localMsgId == temple.content['localMsgId'], orElse: () => null);
    if (find != null) {
      find.status = temple.content['status'];
      ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, data);
    }
  }

  /// 处理单条消息
  static void handleSocketMsg(EntityNoticeTemple temple) async {
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
      ..isRead = 0
      ..senderTime = temple.createTime
      ..msgType = _map['msgType']
      ..msg = _map['msg']
      ..atMembers = _map['atMembers']
      ..status = isSender ? 0 : 1
      ..localMsgId = _map['localMsgId']
      ..msgId = _map["msgId"];
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
