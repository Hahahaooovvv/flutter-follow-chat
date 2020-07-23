import 'dart:convert';

import 'package:follow/apis/memberApi.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';

class NoticeHelper {
  /// 刷新通知
  Future<void> refreshNotice() async {
    String starTime;
    List<EntityNoticeTemple> noticeList = await this.getALlNoticeFromLocal();
    if (noticeList != null && noticeList.isNotEmpty) {
      starTime = noticeList.last.createTime;
    }
    var newNoiceList = await MemberApi().getAllNotice(starTime ?? "2017-11-11");
    if (newNoiceList != null) {
      this.cacheNoticeToLocal(newNoiceList);
    }
  }

  /// 缓存数据到本地
  Future<void> cacheNoticeToLocal(List<EntityNoticeTemple> list) async {
    ReduxUtil.dispatch(ReduxActions.MEMBER_NOTICE_LIST, list);
    await CommonUtil.getSharedPreferencesInstance().then((value) => value.setStringList(SharePreferencesKeys.USER_NOTICE.toString(), list.map((e) => json.encode(e.toJson())).toList()));
  }

  /// 获取本地缓存中的所有通知消息
  Future<List<EntityNoticeTemple>> getALlNoticeFromLocal() {
    return CommonUtil.getSharedPreferencesInstance().then(
      (value) => value.getStringList(SharePreferencesKeys.USER_NOTICE.toString())?.map((e) => EntityNoticeTemple.fromJson(json.decode(e)))?.toList(),
    );
  }
}
