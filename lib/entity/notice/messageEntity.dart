// sender_id,session_id,chat_type,is_read,sender_time,msg_type,msg,at_members,status,msgId

class MessageEntity {
  String senderId;
  String sessionId;
  int chatType;
  int isRead;
  String senderTime;
  // 消息类型 0 文字 1 图片 2 语音
  int msgType;
  String msg;
  dynamic atMembers;
  // 0 发送中或者已经失败 1 发送成功 2 (当前是文件需要上传)
  int status;
  String msgId;
  String localMsgId;
}

class ReduxMessageEntity {
  String sessionId;
  List<MessageEntity> messageList;
}
