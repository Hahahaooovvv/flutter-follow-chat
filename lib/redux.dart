import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/entity/notice/EntityNewesMessage.dart';
import 'package:follow/entity/notice/messageEntity.dart';

class ReduxActionsEntity<T> {
  final ReduxActions type;
  final T data;
  ReduxActionsEntity(this.type, this.data);
}

enum ReduxActions {
  MEMBER_INFO,
  FRIEND_LIST,
  MEMBER_NOTICE_LIST,
  BRIEF_MEMBER_INFO,
  MESSAGE_LIST,

  /// 最新消息
  NEWES_MESSAGE,
  ROOM_MESSAGE,
  CHAT_SESSION_ID
}

class ReduxStore {
  EntityMemberInfo memberInfo;
  List<EntityFriendListInfo> friendList = [];
  List<EntityNoticeTemple> noticeList = [];
  Map<String, EnityBriefMemberInfo> briefMemberInfo = {};
  Map<String, List<MessageEntity>> messageList = {};

  /// 最新消息
  List<EntityNewesMessage> newesMessageList = [];

  List<EntityChatMessage> roomMessageList = [];
  String chatingSessionId;
}

ReduxStore iniReducer(ReduxStore state, dynamic action) {
  ReduxActionsEntity _action = action;
  switch (_action.type) {
    case ReduxActions.MEMBER_INFO:
      state.memberInfo = _action.data;
      return state;
    case ReduxActions.FRIEND_LIST:
      state.friendList = _action.data;
      return state;
    case ReduxActions.MEMBER_NOTICE_LIST:
      state.noticeList = _action.data;
      return state;
    case ReduxActions.MESSAGE_LIST:
      state.messageList = _action.data;
      return state;
    case ReduxActions.BRIEF_MEMBER_INFO:
      state.briefMemberInfo = _action.data;
      return state;
    case ReduxActions.NEWES_MESSAGE:
      state.newesMessageList = _action.data;
      return state;
    case ReduxActions.ROOM_MESSAGE:
      state.roomMessageList = _action.data;
      return state;
    case ReduxActions.CHAT_SESSION_ID:
      state.chatingSessionId = _action.data;
      return state;
    default:
      return state;
  }
}
