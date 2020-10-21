import 'dart:convert';

import 'package:follow/apis/friendApis.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';


class FriendHelper {
  /// 获取好友列表
  Future<void> getFriendList() async {
    await new FriendApis().getFriendList().then((value) async {
      if (value != null) {
        this.cacheFriendListToLocal(value);
        this.cacheToRedux(value);
        var _list = value
            .map((e) => EnityBriefMemberInfo(
                  name: e.nickName,
                  remark: e.remark,
                  avatar: e.avatar,
                  sessionId: e.memberId,
                  isGroup: false,
                ))
            .toList();
        await this.cacheBriefMemberInfoListToDB(_list);
        this.cacheBriefMemberListToRedux();
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
      return value.getStringList(SharePreferencesKeys.FRIEND_LIST.toString())?.map((e) => EntityFriendListInfo.fromJson(json.decode(e)))?.toList() ?? [];
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

  // /// 缓存所有访问过的用户昵称和头像 在进入用户详情和刷新好友信息的时候更新
  // Future<List<EnityBriefMemberInfo>> cacheBriefMemberInfoListToLocal(
  //   List<EnityBriefMemberInfo> list,
  // ) {
  //   return CommonUtil.getSharedPreferencesInstance().then((value) {
  //     List<EnityBriefMemberInfo> _list = value.getStringList(SharePreferencesKeys.BRIEF_MEMBER_INFO.toPrivateUserKeys())?.map((e) => EnityBriefMemberInfo.fromJson(json.decode(e)))?.toList() ?? [];
  //     // 条件跳过
  //     list ??= [];
  //     if (list.isEmpty) {
  //       return _list;
  //     }
  //     list.forEach((element) {
  //       int findIndex = _list.indexWhere((e) => e.sessionId != element.sessionId);
  //       if (findIndex > -1) {
  //         _list[findIndex] = element;
  //       } else {
  //         _list.add(element);
  //       }
  //     });
  //     value.setStringList(SharePreferencesKeys.BRIEF_MEMBER_INFO.toPrivateUserKeys(), _list.map((e) => e.toJson().jsonEncode()).toList());
  //     return _list;
  //   });
  // }

  // // 缓存用户简略信息到redux
  // Future<void> cacheBriefMemberInfoListToRedux([List<EnityBriefMemberInfo> list]) async {
  //   Map<String, EnityBriefMemberInfo> _map = {};
  //   list ??= [];
  //   var localList = await CommonUtil.getSharedPreferencesInstance().then((value) {
  //     List<EnityBriefMemberInfo> _list = value.getStringList(SharePreferencesKeys.BRIEF_MEMBER_INFO.toPrivateUserKeys())?.map((e) => EnityBriefMemberInfo.fromJson(json.decode(e)))?.toList() ?? [];
  //     return _list;
  //   });
  //   list.forEach((p) {
  //     var _index = localList.indexWhere((element) => element.sessionId == p.sessionId);
  //     if (_index > -1) {
  //       localList[_index] = p;
  //     } else {
  //       localList.add(p);
  //     }
  //   });
  //   if (localList.length == 0) {
  //     return;
  //   }
  //   localList.forEach((element) {
  //     _map[element.sessionId] = element;
  //   }); // '1a2a4d6cfbab4d14a6c2b575bfbc3ebe'
  //   ReduxUtil.dispatch(ReduxActions.BRIEF_MEMBER_INFO, _map);
  // }

  // /// 获取用户简略信息
  // static Map<String, EnityBriefMemberInfo> getBriefMemberInfos(List<String> sessionIds, {bool getIfNull: true}) {
  //   Map<String, EnityBriefMemberInfo> _map = {};
  //   List<String> getIds = [];
  //   var briefMemberInfos = ReduxUtil.store.state.briefMemberInfo;
  //   sessionIds.forEach((e) {
  //     var find = briefMemberInfos[e];
  //     if (find == null) {
  //       getIds.add(e);
  //     } else {
  //       _map[e] = find..nameOrRemark = (find.remark ?? find.name);
  //     }
  //   });
  //   // 如果没有 就获取
  //   if (getIfNull && getIds.length != 0) {
  //     MemberApi().getBriefMemberInfo(getIds.join(',')).then((value) {
  //       List<EnityBriefMemberInfo> defaultList = value.deepCopy();
  //       getIds.forEach((element) {
  //         if (!defaultList.any((p) => p.sessionId == element)) {
  //           // 如果没有查询到 就给默认的值
  //           defaultList.add(EnityBriefMemberInfo(
  //             sessionId: element,
  //             avatar: "http://wechat-demo-zdc.oss-cn-chengdu.aliyuncs.com/default_avatar.jpg",
  //             name: "不存在用户",
  //             remark: null,
  //             isGroup: false,
  //             nameOrRemark: "不存在用户",
  //           ));
  //         }
  //       });
  //       FriendHelper friendHelper = new FriendHelper();
  //       friendHelper.cacheBriefMemberInfoListToLocal(defaultList);
  //       friendHelper.cacheBriefMemberInfoListToRedux(defaultList);
  //     }).catchError((e) {
  //       List<EnityBriefMemberInfo> _list = <EnityBriefMemberInfo>[];
  //       getIds.forEach((element) {
  //         _list.add(EnityBriefMemberInfo(
  //           sessionId: element,
  //           avatar: "http://wechat-demo-zdc.oss-cn-chengdu.aliyuncs.com/default_avatar.jpg",
  //           name: "不存在用户",
  //           remark: null,
  //           isGroup: false,
  //           nameOrRemark: "不存在用户",
  //         ));
  //       });
  //       FriendHelper friendHelper = new FriendHelper();
  //       friendHelper.cacheBriefMemberInfoListToLocal(_list);
  //       friendHelper.cacheBriefMemberInfoListToRedux(_list);
  //     });
  //   }
  //   return _map;
  // }

  Future<void> getBriefInfos(List<String> sessionIds) async {
    await MemberApi().getBriefMemberInfo(sessionIds.join(',')).then((value) async {
      if (value != null && value.isNotEmpty) {
        await this.cacheBriefMemberInfoListToDB(value);
        await this.cacheBriefMemberListToRedux();
        return value;
      }
    });
  }

  /// 缓存所有访问过的用户昵称和头像 在进入用户详情和刷新好友信息的时候更新
  Future<void> cacheBriefMemberInfoListToDB(List<EnityBriefMemberInfo> list) async {
    if (list.length == 0) {
      return;
    }
    SqlUtilTransactionTemple sqlUtilTemple = list.getInsertDbTStr(mapIds: (item) => item.sessionId);
    String keys = SqlLiteUtil.getKeys(sqlUtilTemple.ids.length);
    await SqlLiteUtil.dbInstance.execute("delete from ebrief_info where  sessionId in($keys)", sqlUtilTemple.ids);
    // await SqlLiteUtil.dbInstance.execute(sqlUtilTemple.sqlStr, sqlUtilTemple.dataList);
    await SqlLiteUtil().transactions(sqlUtilTemple.temple);
  }

  /// 通过ID缓存到redux 中间会检查是否有头像
  Future<void> cacheBriefMemberListToReduxBySessionId(List<String> ids) async {
    if (ids.isNotEmpty) {
      List<String> nullIds = [];
      List<EnityBriefMemberInfo> _dbList =
          await SqlLiteUtil().getListFromDB("select * from ebrief_info where sessionId in(${SqlLiteUtil.getKeys(ids.length)})", data: ids, mapToList: (item) => EnityBriefMemberInfo.fromJson(item));
      ids.forEach((p) {
        if (!_dbList.any((element) => element.sessionId == p)) {
          nullIds.add(p);
        }
      });
      if (nullIds.length > 0) {
        await this.getBriefInfos(nullIds);
      }
    }
  }

  /// 缓存所有访问过的用户昵称和头像 在进入用户详情和刷新好友信息的时候更新
  Future<void> cacheBriefMemberListToRedux() async {
    List<EnityBriefMemberInfo> _dbList = await SqlLiteUtil().getListFromDB("select * from ebrief_info", mapToList: (item) => EnityBriefMemberInfo.fromJson(item));
    Map<String, EnityBriefMemberInfo> _map = {};
    _dbList.forEach((element) {
      _map[element.sessionId] = element;
    });
    ReduxUtil.dispatch(ReduxActions.BRIEF_MEMBER_INFO, _map);
  }
}
