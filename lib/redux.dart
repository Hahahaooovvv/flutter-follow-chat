import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
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
  MESSAGE_LIST,
}

class ReduxStore {
  EntityMemberInfo memberInfo;
  List<EntityFriendListInfo> friendList = [];
  List<EntityNoticeTemple> noticeList = [];
  Map<String, List<MessageEntity>> messageList = {};
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
    default:
      return state;
  }
}
