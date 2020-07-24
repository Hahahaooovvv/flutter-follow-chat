import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/notice/messageEntity.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

class MessageUtil {
  static SqlTemple getSocketMsgSqlStr(EntityNoticeTemple temple) {
    String str = "insert into chat_message(sender_id,session_id,chat_type,is_read,sender_time,msg_type,msg,at_members,status,msgId) values(?,?,?,?,?,?,?,?,?,?)";
    Map<dynamic, dynamic> _map = temple.content;
    return SqlTemple()
      ..sqlStr = str
      ..dataList = [temple.senderId, getSessionId(temple.senderId, temple.receiveId), temple.type, 0, temple.createTime, _map['msgType'], _map['msg'], null, 1, _map["msgId"]];
  }

  static getSessionId(String senderId, String receiveId) {
    if (senderId == ReduxUtil.store.state.memberInfo.memberId) {
      return receiveId;
    } else {
      return senderId;
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
    // 开始回执已收到
    SocketUtil.webSocketInstance.add(EntityNoticeTemple(content: _map['offlineId'], type: 2, isRead: 0, createTime: DateTime.now().toIso8601String()).toJson().jsonEncode());
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
      ..status = 1
      ..msgId = _map["msgId"];
    if (data[temple.receiveId] != null) {
      data[temple.receiveId].add(entity);
    } else {
      data[temple.receiveId] = <MessageEntity>[entity];
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
      if (_map['session_id'] != null) {
        _map['session_id'].add(entity);
      } else {
        _map['session_id'] = [entity];
      }
    });
    ReduxUtil.dispatch(ReduxActions.MESSAGE_LIST, _map);
    return _map;
  }
}
