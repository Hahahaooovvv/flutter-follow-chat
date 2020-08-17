import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

class EntityChatMessageExtend {
  /// 图片 或者视屏的宽和高
  Size size;
}

/// 聊天消息实体
class EntityChatMessage {
  int id;

  /// 消息ID
  String msgId;

  /// 聊天对象 如果为1 则是群号
  String sessionId;

  /// 0 单聊  1 群聊
  int chatType;

  /// 具体消息
  String msg;

  /// 0 发送中 1 未发送
  int status;

  /// 本地处理的status 0 未处理(比如图片、语音或者视频未上传) 1 处理中（上传中、或者已经上传失败） 2 已处理
  int localStatus;

  /// 0 普通消息 1 图片消息 2 语音消息 3 视屏消息
  int msgType;

  /// 本地的临时ID 用于处理发送消息处理的回执
  String localId;

  /// 接收时间
  DateTime time;

  /// 如果是群聊 则是艾特的人
  String atMembersId;

  /// 是否阅读
  int isRead;

  /// 是否撤回
  int isWithdraw;

  /// 是否发送人
  String senderId;

  /// 文件流 只有在聊天的时候这个对象才会有
  File file;

  /// 图片或者是
  EntityChatMessageExtend extend;

  /// 文件流
  StreamController<double> streamController;

  EntityChatMessage(
      {this.id,
      this.msgId,
      this.sessionId,
      this.chatType,
      this.msg,
      this.status,
      this.localStatus,
      this.msgType,
      this.localId,
      this.time,
      this.atMembersId,
      this.isRead,
      this.isWithdraw,
      this.senderId,
      this.file,
      this.streamController});

  EntityChatMessage merge(EntityChatMessage message) {
    EntityChatMessage _obj = EntityChatMessage();
    _obj.id = message.id ?? this.id;
    _obj.msgId = message.msgId ?? this.msgId;
    _obj.sessionId = message.sessionId ?? this.sessionId;
    _obj.chatType = message.chatType ?? this.chatType;
    _obj.msg = message.msg ?? this.msg;
    _obj.status = message.status ?? this.status;
    _obj.localStatus = message.localStatus ?? this.localStatus;
    _obj.msgType = message.msgType ?? this.msgType;
    _obj.localId = message.localId ?? this.localId;
    _obj.time = message.time ?? this.time;
    _obj.atMembersId = message.atMembersId ?? this.atMembersId;
    _obj.isRead = message.isRead ?? this.isRead;
    _obj.isWithdraw = message.isWithdraw ?? this.isWithdraw;
    _obj.senderId = message.senderId ?? this.senderId;
    return _obj;
  }

  EntityChatMessage.formFastSend({
    @required String setMsg,
    @required String setSessionId,
    @required int setMsgType,
  }) {
    id = null;
    msgId = null;
    sessionId = setSessionId;
    chatType = 0;
    msg = setMsg;
    status = 0;
    localStatus = 0;
    msgType = setMsgType;
    localId = CommonUtil.randomString();
    time = DateTime.now();
    atMembersId = null;
    isRead = 0;
    isWithdraw = 0;
    senderId = ReduxUtil.store.state.memberInfo.memberId;
  }

  EntityChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msgId = json['msgId'];
    sessionId = json['sessionId'];
    chatType = json['chatType'];
    msg = json['msg'];
    status = json['status'];
    localStatus = json['localStatus'];
    msgType = json['msgType'];
    localId = json['localId'];
    if (json['time'] is int) {
      time = DateTime.fromMillisecondsSinceEpoch(json['time']);
    } else {
      time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['time']));
    }
    atMembersId = json['atMembersId'];
    isRead = json['isRead'];
    isWithdraw = json['isWithdraw'];
    senderId = json["senderId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msgId'] = this.msgId;
    data['sessionId'] = this.sessionId;
    data['chatType'] = this.chatType;
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['localStatus'] = this.localStatus;
    data['msgType'] = this.msgType;
    data['localId'] = this.localId;
    data['time'] = this.time.millisecondsSinceEpoch;
    data['atMembersId'] = this.atMembersId;
    data['isRead'] = this.isRead;
    data['isWithdraw'] = this.isWithdraw;
    data['senderId'] = this.senderId;
    return data;
  }
}

// extension EntityChatMessageExtension on List<EntityChatMessage> {
//   Map<String, dynamic> toSql() {
//     String strSql = "";
//     List<dynamic> data = [];
//     this.forEach((element) {
//       String keys = "";
//       String values = "";
//       var _json = element.toJson();
//       _json.keys.toList().forEach((e) {
//         if (_json[e] != null) {
//           keys += keys.isNotEmpty ? "," + e : e;
//           values += values.isNotEmpty ? ",?" : "?";
//           data.add(_json[e]);
//         }
//       });
//       strSql += "INSERT INTO CHAT_MSG($keys) VALUES($values);";
//     });
//     return {"sql": strSql, "data": data};
//   }
// }
