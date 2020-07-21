import 'dart:convert';

import 'package:follow/apis/friendApis.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

class FriendHelper {
  /// 获取好友列表
  getFriendList() async {
    await new FriendApis().getFriendList().then((value) {
      if (value != null) {
        this.cacheFriendListToLocal(value);
        this.cacheFriendListToRedux(value);
      }
    });
  }

  /// 缓存好友
  cacheFriendListToLocal(List<EntityFriendListInfo> list) {
    CommonUtil.getSharedPreferencesInstance().then((value) {
      value.setStringList(SharePreferencesKeys.FRIEND_LIST.toString(), list.map((e) => json.encode(e.toJson())).toList());
    });
  }

  /// 缓存好友到redux
  cacheFriendListToRedux(List<EntityFriendListInfo> list) {
    ReduxUtil.dispatch(ReduxActions.FRIEND_LIST, list);
  }
}
