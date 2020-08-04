// sender_id,session_id,chat_type,is_read,sender_time,msg_type,msg,at_members,status,msgId

class MessageEntity {
  String senderId;
  String sessionId;
  int chatType;
  int isRead;
  String senderTime;
  int msgType;
  String msg;
  dynamic atMembers;
  int status;
  String msgId;
  String localMsgId;
}

class ReduxMessageEntity {
  String sessionId;
  List<MessageEntity> messageList;
}
