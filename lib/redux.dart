import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';

class ReduxActionsEntity<T> {
  final ReduxActions type;
  final T data;
  ReduxActionsEntity(this.type, this.data);
}

enum ReduxActions {
  MEMBER_INFO,
  FRIEND_LIST,
}

class ReduxStore {
  EntityMemberInfo memberInfo;
  List<EntityFriendListInfo> friendList = [];
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
    default:
      return state;
  }
}
