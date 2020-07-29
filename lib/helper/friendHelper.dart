import 'dart:convert';

import 'package:follow/apis/friendApis.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

class FriendHelper {
  /// 获取好友列表
  Future<void> getFriendList() async {
    await new FriendApis().getFriendList().then((value) {
      if (value != null) {
        this.cacheFriendListToLocal(value);
        this.cacheToRedux(value);
      }
    });
  }

  /// 缓存好友
  void cacheFriendListToLocal(List<EntityFriendListInfo> list) {
    CommonUtil.getSharedPreferencesInstance().then((value) {
      value.setStringList(SharePreferencesKeys.FRIEND_LIST.toString(), list.map((e) => json.encode(e.toJson())).toList());
    });
  }

  Future<List<EntityFriendListInfo>> getFriendListFromLocal() {
    return CommonUtil.getSharedPreferencesInstance().then((value) {
      return value.getStringList(SharePreferencesKeys.FRIEND_LIST.toString()).map((e) => EntityFriendListInfo.fromJson(json.decode(e))).toList();
    });
  }

  /// 缓存好友到redux
  void cacheToRedux([List<EntityFriendListInfo> list]) async {
    ReduxUtil.dispatch(ReduxActions.FRIEND_LIST, list ?? (await this.getFriendListFromLocal()));
  }

  /// 获取好友信息
  static EntityFriendListInfo getFreindInfo(String memberId, [List<EntityFriendListInfo> list]) {
    return ReduxUtil.store.state.friendList.firstWhere((element) => element.memberId == memberId, orElse: () => null);
  }
}
